class AddCategoryIdToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :category_id, :integer

  end
end
