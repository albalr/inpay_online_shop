class ProductsController < ApplicationController
  # GET /products
  def index
    products = Product.all
    if products.empty?
      render json: { error: 'No products found' }, status: :not_found
    else
      render json: products
    end
  end

  # GET /products/:id
  def show
    product = Product.find_by(id: params[:id])
    if product
      render json: product
    else
      render json: { error: "Product with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # POST /products
  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      # All required parameters are present, but validations failed
      render json: { error: product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing => e
    # Required parameter is missing entirely
    render json: { error: "Missing parameter: #{e.param}" }, status: :bad_request
  end

  private

  # Parameters for product creation
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity)
  end
end
