class AddNotNullConstraints < ActiveRecord::Migration
  def change
      change_column_null(:events,:created_at,false)
      change_column_null(:events,:updated_at,false) 
  end
end
