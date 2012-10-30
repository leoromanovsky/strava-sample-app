class AddStravaUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :strava_uid, :string
  end
end
