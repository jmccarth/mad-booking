class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :parent_booking_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
