class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :quantity_less_than_or_equal_to_product_stock

  private

  def quantity_less_than_or_equal_to_product_stock
    return unless product && quantity # if product and quantity are not present, return
    if quantity > product.stock_quantity
      errors.add(:quantity, "exceeds product stock")
    end
  end
end
