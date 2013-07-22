class CreateBookingsEquipments < ActiveRecord::Migration
  def up
  end

  def down
  end
  
  def change
    create_table :bookings_equipment, id:false do |t|
      t.integer :booking_id
      t.integer :equipment_id
    end
  end
end
