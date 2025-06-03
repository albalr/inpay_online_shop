class ShopController < ApplicationController
  def index
    @products = Product.where(archived: [false, nil])
  end
end
