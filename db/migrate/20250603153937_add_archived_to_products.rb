class AddArchivedToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :archived, :boolean
  end
end
