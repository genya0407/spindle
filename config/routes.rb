Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope path: ".well-known", module: :well_known do
    resource :webfinger, only: %i[show]
  end

  resources :users, only: %i[show] do
    member do
      post :inbox, to: "users/inbox#create"
    end
  end
end
