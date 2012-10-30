class OAuthsController < ApplicationController
  def strava
    if params[:code]
      client_options = {site: 'http://dev.strava.com', parse: :json}

      client = OAuth2::Client.new(Settings.strava.app_id, Settings.strava.app_secret, client_options)
      authorization = client.auth_code.get_token(params[:code])

      token = OAuth2::AccessToken.new(
        client,
        authorization.token,
        param_name: :access_token,
        mode: :query)

      myself = token.get('/api/v3/athlete').parsed

      @athlete = myself
    end
  else
    @error = params[:error]
  end
end
