class ChangeScheduleColumnType < ActiveRecord::Migration
  def change
  	change_column :bookings, :schedule, :text
  end
end
