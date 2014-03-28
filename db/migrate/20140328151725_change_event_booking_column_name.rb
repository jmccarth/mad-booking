class ChangeEventBookingColumnName < ActiveRecord::Migration
  def change
  	rename_column :events, :parent_booking_id, :booking_id
  end
end
