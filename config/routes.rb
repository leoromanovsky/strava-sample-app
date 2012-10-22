SampleApp::Application.routes.draw do
  resource :o_auth do
    member do
      get :strava
    end
  end

  root :to => 'website#home'
end
