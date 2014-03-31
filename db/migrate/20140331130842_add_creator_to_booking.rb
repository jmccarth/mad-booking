class AddCreatorToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :creator, :string
  end
end
