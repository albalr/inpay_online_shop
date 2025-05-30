class OrdersController < ApplicationController

  # GET /orders
  def index
    orders = Order.includes(order_items: :product).all
    render json: orders.to_json(include: { order_items: { include: :product } })
  end

  # GET /orders/:id
  def show
    order = Order.find(params[:id])
    render json: order.to_json(include: { order_items: { include: :product } })
  end

  # POST /orders
  def create
    order = Order.new(status: "pending")
    if order.save
      params[:items].each do |item|
        product = Product.find(item[:product_id])
        quantity = item[:quantity]
        order.order_items.create(product: product, quantity: quantity)
      end

      total = order.order_items.includes(:product).sum do |oi|
        oi.quantity * oi.product.price
      end
      order.update(total_amount: total)

      render json: order.to_json(include: { order_items: { include: :product } }), status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end
end