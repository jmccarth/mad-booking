class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :user
      t.string :equip_bc
      t.string :schedule

      t.timestamps
    end
  end
end
