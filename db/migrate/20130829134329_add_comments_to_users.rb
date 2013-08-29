class AddCommentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comments, :text

  end
end
