# config/routes.rb

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]  # Desabilita registro nas rotas
  
  root "home#index"
  
  namespace :admin do
    root "dashboard#index"
    resources :users
  end
  
  get "home", to: "home#index"
end
