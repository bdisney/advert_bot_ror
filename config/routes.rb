Rails.application.routes.draw do
  root 'accounts#index'

  resources :accounts
  resources :apps
end
