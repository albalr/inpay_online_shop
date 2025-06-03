class ProductsController < ApplicationController

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products
  def index
    products = Product.where(archived: [false, nil])
    render json: products
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

    respond_to do |format|
      if @product.save
        format.html { redirect_to root_path, notice: "Product created!" }
        format.json { render json: @product, status: :created }
      else
        format.html { redirect_to root_path, alert: @product.errors.full_messages.to_sentence }
        format.json { render json: { error: @product.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  rescue ActionController::ParameterMissing => e
    # Required parameter is missing entirely
    redirect_to root_path, alert: "Missing parameter: #{e.param}"
  end

  # DELETE /products/:id
  def destroy
    product = Product.find_by(id: params[:id])

    if product
      product.update(archived: true)

      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Product deleted successfully" }
        format.json { render json: { message: "Product deleted successfully" }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: "Product not found" }
        format.json { render json: { error: "Product not found" }, status: :not_found }
      end
    end
  end

  private

  # Parameters for product creation
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity)
  end
end
