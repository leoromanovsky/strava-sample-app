class AddInstagramToUser < ActiveRecord::Migration
  def change
    add_column :users, :instagram_access_token, :string
    add_column :users, :instagram_uid, :string
    add_column :users, :instagram_username, :string
  end
end
