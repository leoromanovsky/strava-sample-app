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

  def instagram
    client_options = {
      site: Settings.instagram.host,
      redirect_uri: instagram_o_auth_url,
      authorize_url: '/oauth/authorize',
      token_url: '/oauth/access_token',
      parse: :json}
    client = OAuth2::Client.new(Settings.instagram.client_id, Settings.instagram.client_secret, client_options)
    authorization = client.auth_code.get_token(
      params[:code],
      redirect_uri: "#{Settings.host}#{instagram_o_auth_path}",
      parse: :json)

    user = User.find(1)
    user.instagram_access_token =  authorization.token
    user.instagram_uid = authorization['user']['id']
    user.instagram_username = authorization['user']['username']
    user.save!

    redirect_to(user_path(user))
  rescue OAuth2::Error => e
    puts e.inspect
  end

  private

  # Generates an authorization URL.
  def authorize_url
    authorization_parameters = {
      response_type: 'code',
      redirect_uri:  instagram_o_auth_url,
      state:         'authorize_strava',
      access_type:   'offline'
    }
    config.auth_code.authorize_url(authorization_parameters)
  end
end
