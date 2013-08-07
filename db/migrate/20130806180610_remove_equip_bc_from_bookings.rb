class RemoveEquipBcFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :equip_bc
  end

  def down
    add_column :bookings, :equip_bc, :string
  end
  
end
