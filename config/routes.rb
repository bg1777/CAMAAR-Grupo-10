# config/routes.rb

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
    
    # Form Templates
    resources :form_templates do
      resources :form_template_fields, only: [:create, :update, :destroy]
    end
    
    # Forms
    resources :forms do
      member do
        patch :publish
        patch :close
        get :view_response
      end
    end
  end

  # Student namespace
  namespace :student do
    root "dashboard#index"
    resources :forms, only: [:index, :show] do
      member do
        get :answer
        post :submit_answer
      end
    end
  end
  
  get "home", to: "home#index"
end
