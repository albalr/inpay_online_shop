class ShopController < ApplicationController

  # GET /shop
  def index
    @products = Product.where(archived: false)
  end
end

