class OAuthsController < ApplicationController

  def strava
    if params[:code]
      client_options = {
        site: 'http://localhost:3000',
        parse: :json
      }

      client = OAuth2::Client.new(10, '3eeaa2afb05e3feb66e092f558e940769dbf65ff', client_options)
      authorization = client.auth_code.get_token(params[:code])

      token = OAuth2::AccessToken.new(
        client,
        authorization.token,
        param_name: :access_token,
        mode: :query
      )

      puts "AUTH #{authorization.inspect}"
      myself = token.get('/api/v3/athlete').parsed
      puts "MYSELF #{myself}"

      @athlete = myself

    end
  else
    @error = params[:error]
  end

end
