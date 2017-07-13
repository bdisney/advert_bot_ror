require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'accounts#index'

  resources :accounts do
    get :refresh_status, on: :member
    get :show_log, on: :member
    post :synchronize, on: :member
  end
  resources :apps
end
