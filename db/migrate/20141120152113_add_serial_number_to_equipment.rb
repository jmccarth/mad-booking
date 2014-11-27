class AddSerialNumberToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :serial_number, :string
  end
end
