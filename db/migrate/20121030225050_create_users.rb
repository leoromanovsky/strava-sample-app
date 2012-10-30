class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :strava_oauth

      t.timestamps
    end
  end
end
