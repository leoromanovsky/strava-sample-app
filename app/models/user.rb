class User < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :profile_picture, :recent_ride_totals, :recent_run_totals
  attr_accessible :strava_uid, :strava_oauth

  def self.num_users
    Rails.cache.fetch('num_users') do
      User.count
    end
  end
end
