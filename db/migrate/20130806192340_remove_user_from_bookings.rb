class RemoveUserFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :user
  end

  def down
    add_column :bookings, :user, :string
  end
  
end
