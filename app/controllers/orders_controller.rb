class OrdersController < ApplicationController

  # GET /orders
  def index
    orders = Order.includes(order_items: :product).all
    if orders.empty?
      render json: { error: 'No orders found' }, status: :not_found
    else
      render json: orders.to_json(include: { order_items: { include: :product } })
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

        params[:items].each do |item|
          product_id = item[:product_id]
          quantity = item[:quantity]
          product = Product.find(product_id)
          order.order_items.create!(product: product, quantity: quantity)
        end

        total = order.order_items.includes(:product).sum do |oi|
          oi.quantity * oi.product.price
        end
        order.update(total_amount: total)

        render json: order.to_json(include: { order_items: { include: :product } }), status: :created

      rescue ActiveRecord::RecordNotFound
        order.destroy
        render json: { error: "Product with id #{product_id} not found" }, status: :unprocessable_entity

      rescue => e
        order.destroy
        render json: { error: "Error creating order: #{e.message}" }, status: :unprocessable_entity
      end
    else
      render json: { error: order.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
