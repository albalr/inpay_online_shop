class ProductsController < ApplicationController

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products
  def index
    products = Product.where(archived: [false, nil])
    if products.empty?
      render json: { error: 'No products found' }, status: :not_found
    else
      render json: products
    end
  end

  # GET /products/:id
  def show
    product = Product.find_by(id: params[:id], archived: [false, nil])
    if product
      render json: product
    else
      render json: { error: "Product with id #{params[:id]} not found" }, status: :not_found
    end
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if request.format.json?
      if @product.save
        render json: @product, status: :created
      else
        render json: { error: @product.errors.full_messages }, status: :unprocessable_entity
      end
    else
      if @product.save
        redirect_to root_path, notice: "Product created!"
      else
        redirect_to root_path, alert: @product.errors.full_messages.to_sentence
      end
    end
  rescue ActionController::ParameterMissing => e
    if request.format.json?
      render json: { error: "Missing parameter: #{e.param}" }, status: :unprocessable_entity
    else
      redirect_to root_path, alert: "Missing parameter: #{e.param}"
    end
  end

  # DELETE /products/:id
  def destroy
    product = Product.find_by(id: params[:id])
    if request.format.json?
      if product
        product.update(archived: true)
        render json: { message: "Product deleted successfully" }, status: :ok
      else
        render json: { error: "Product not found" }, status: :not_found
      end
    else
      if product
        product.update(archived: true)
        redirect_back fallback_location: root_path, notice: "Product deleted successfully"
      else
        redirect_back fallback_location: root_path, alert: "Product not found"
      end
    end
  end

  private

  # Parameters for product creation
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity)
  end
end
