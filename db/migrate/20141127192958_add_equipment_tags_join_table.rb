class AddEquipmentTagsJoinTable < ActiveRecord::Migration
  def change
    create_table :equipment_tags, :id => false do |t|
      t.integer :equipment_id
      t.integer :tag_id
    end
  end
end
