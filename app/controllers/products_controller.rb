class ProductsController < ApplicationController
  # GET /products
  def index
    render json: Product.all
  end

  # GET /products/:id
  def show
    product = Product.find(params[:id])
    render json: product
  end

  # POST /products
  def create
    product = Product.new(product_params)
    if product.save
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  private
  # Parameters for product creation
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity)
  end
end