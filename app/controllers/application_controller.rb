class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :calculate_num_users

  def calculate_num_users
    @num_users = User.num_users
  end
end
