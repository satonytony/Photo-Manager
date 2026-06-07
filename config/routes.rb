Rails.application.routes.draw do
  root "sessions#new"

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  resources :photos, only: [ :index, :new, :create ]

  get "/oauth/authorize", to: "oauth#authorize", as: :oauth_authorize
  get "/oauth/callback",  to: "oauth#callback",  as: :oauth_callback

  get "up" => "rails/health#show", as: :rails_health_check
end
