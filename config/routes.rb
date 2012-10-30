SampleApp::Application.routes.draw do
  resource :o_auth do
    member do
      get :strava
    end
  end

  resources :users, only: [:show]

  root :to => 'website#home'
end
