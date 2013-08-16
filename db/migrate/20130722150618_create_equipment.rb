class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :barcode
      t.string :name
      t.string :stored

      t.timestamps
    end
  end
end
