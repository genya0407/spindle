Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/nodeinfo/2.0", to: "nodeinfos#show"
  scope path: ".well-known", module: :well_known do
    resource :webfinger, only: %i[show]
    resource :nodeinfo, only: %i[show]
  end

  resources :users, only: %i[show] do
    member do
      get :followers
      get :following
      post :inbox, to: "users/inbox#create"
      post :outbox, to: "users/outbox#create"
    end
  end
end
