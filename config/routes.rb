Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  
  root "home#index"
  
  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :imports, only: [:index] do
      collection do
        post :import_klasses
      end
    end
  end
  
  get "home", to: "home#index"
end
