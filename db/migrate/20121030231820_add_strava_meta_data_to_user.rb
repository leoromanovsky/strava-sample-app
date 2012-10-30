class AddStravaMetaDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :profile_picture, :string
    add_column :users, :recent_ride_totals, :integer
    add_column :users, :recent_run_totals, :integer
  end
end
