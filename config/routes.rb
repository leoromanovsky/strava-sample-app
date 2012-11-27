SampleApp::Application.routes.draw do
  resource :o_auth do
    member do
      get :strava
      get :instagram
      get :instagram_initiate_pubsub
      get :instagram_pubsub_callback
    end
  end

  resources :users, only: [:show]

  root :to => 'website#home'
end
