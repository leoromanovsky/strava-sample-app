SampleApp::Application.routes.draw do
  resource :o_auth do
    member do
      get :strava
      get :instagram
    end
  end

  resources :users, only: [:show]

  root :to => 'website#home'
end
