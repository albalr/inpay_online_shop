class ProductsController < ApplicationController

  # GET /products/new
  def new
    @product = Product.new
  end

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
    @product = Product.new(product_params)

    if @product.save
      redirect_to root_path, notice: "Product created!"
    else
      # All required parameters are present, but validations failed
      redirect_to root_path, alert: @product.errors.full_messages.to_sentence
    end
  rescue ActionController::ParameterMissing => e
    # Required parameter is missing entirely
    redirect_to root_path, alert: "Missing parameter: #{e.param}"
  end

  private

  # Parameters for product creation
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity)
  end
end
