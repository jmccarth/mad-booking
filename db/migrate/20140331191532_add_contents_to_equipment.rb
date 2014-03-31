class AddContentsToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :contents, :string
  end
end
