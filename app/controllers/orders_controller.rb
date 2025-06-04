class OrdersController < ApplicationController

  # GET /orders
  def index
    @orders = Order.includes(order_items: :product).all

    respond_to do |format|
      format.html
      format.json do
        if @orders.empty?
          render json: { error: 'No orders found' }, status: :not_found
        else
          render json: @orders.to_json(include: { order_items: { include: :product } })
        end
      end
    end
  end

  # GET /orders/:id
  def show
    order = Order.find_by(id: params[:id])
    if order
      render json: order.to_json(include: { order_items: { include: :product } })
    else
      render json: { error: "Order with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # POST /orders
  def create
    order = Order.new(status: "pending")

    if order.save
      begin
        product_id = nil

        # Iterate through each item in the params
        params[:items].each do |item|
          product_id = item[:product_id]
          quantity = item[:quantity].to_i
          product = Product.find_by(id: product_id, archived: false)

          order.order_items.create(product: product, quantity: quantity)

          # Update the stock quantity of the product
          new_quantity = product.stock_quantity - quantity
          if new_quantity == 0
            product.update_columns(stock_quantity: 0, archived: true)
          else
            product.update(stock_quantity: new_quantity)
          end
        end

        total = order.order_items.includes(:product).sum do |oi|
          oi.quantity * oi.product.price
        end

        order.update(total_amount: total)

        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, notice: "Order created successfully" }
          format.json { render json: order.to_json(include: { order_items: { include: :product } }), status: :created }
        end

      rescue ActiveRecord::RecordNotFound
        order.destroy
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Product with id #{product_id} not found" }
          format.json { render json: { error: "Product with id #{product_id} not found" }, status: :unprocessable_entity }
        end

      rescue => e
        order.destroy
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: "Error creating order: #{e.message}" }
          format.json { render json: { error: "Error creating order: #{e.message}" }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: order.errors.full_messages.to_sentence }
        format.json { render json: { error: order.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end
