class AddDefaultToArchivedInProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_default :products, :archived, from: nil, to: false
    Product.where(archived: nil).update_all(archived: false)
  end
end