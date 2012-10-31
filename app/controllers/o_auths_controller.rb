class OAuthsController < ApplicationController
  def strava
    if params[:code]
      # Retrieve the access token.
      client_options = {site: Settings.strava.host, parse: :json}
      client = OAuth2::Client.new(Settings.strava.app_id, Settings.strava.app_secret, client_options)
      authorization = client.auth_code.get_token(params[:code])

      token = OAuth2::AccessToken.new(
        client,
        authorization.token,
        param_name: :access_token,
        mode: :query)

      myself = token.get('/api/v3/athlete').parsed
      myself = myself.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

      # create user if they do not exist.
      user = User.find_or_create_by_strava_uid(myself[:id].to_s)
      user.strava_oauth = authorization.token
      user.firstname = myself[:firstname]
      user.lastname = myself[:lastname]
      user.profile_picture = myself[:profile]
      user.save

      # update the user count cache
      Rails.cache.write('num_users', User.count)

      # redirect to the user's profile
      redirect_to(user_path(user))
    else
      @error = params[:error]
    end
  rescue OAuth2::Error => e
    @error = e
  end
end
