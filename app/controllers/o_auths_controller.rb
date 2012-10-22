class OAuthsController < ApplicationController

  def strava
    if params[:code]
      client_options = {
        site: 'http://localhost:3000',
        parse: :json
      }

      client = OAuth2::Client.new(12, 'd9c1cd4f3e3c1e18dd07af69eb7c87299ea93ef8', client_options)
      authorization = client.auth_code.get_token(params[:code])
      puts "AUTH #{authorization.inspect}"
    end

  end

end
