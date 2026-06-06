Rails.application.routes.draw do
  root "sessions#new"

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"

  resources :photos, only: [ :index, :new, :create ]

  get "up" => "rails/health#show", as: :rails_health_check
end
