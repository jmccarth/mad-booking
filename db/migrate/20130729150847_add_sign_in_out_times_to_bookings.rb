class AddSignInOutTimesToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :sign_in_times, :text

    add_column :bookings, :sign_out_times, :text

  end
end
