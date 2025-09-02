Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
    end
  end
end
