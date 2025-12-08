# config/routes.rb

Rails.application.routes.draw do
  get "home/index"
  devise_for :users
  
  # Root path
  root "home#index"
  
  # Admin dashboard
  namespace :admin do
    get "users/index"
    get "users/show"
    get "users/edit"
    get "users/update"
    get "users/destroy"
    get "dashboard/index"
    root "dashboard#index"
    resources :users
  end
  
  # Home public
  get "home", to: "home#index"
end
