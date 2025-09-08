Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      post 'login', to: 'sessions#create'
      resource :profile, only: [:show, :update]
      resources :workout_plans, only: [:create]
    end
  end
end
