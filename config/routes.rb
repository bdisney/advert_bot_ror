Rails.application.routes.draw do
  root 'accounts#index'

  resources :accounts do
    post :synchronize, on: :member
  end
  resources :apps
end
