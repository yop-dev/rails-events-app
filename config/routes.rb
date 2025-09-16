Rails.application.routes.draw do
  # Landing page
  root 'home#index'

  # Regular users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }, path_names: {
    sign_up: 'register'
  }

  # Admin users - with custom controllers
  devise_for :admin_users, controllers: {
    registrations: 'admins/registrations',
    sessions: 'admins/sessions'
  }, class_name: 'User', path: 'admin', path_names: {
    sign_up: 'register',
    sign_in: 'login',
    sign_out: 'logout'
  }

  # Admin namespace (protected area - ONLY the dashboard should be protected)
  # Events management (for regular users)
  resources :events do
    resources :event_registrations, only: [:create], controller: 'registrations'
  end
  
  resources :event_registrations, only: [:edit, :update, :destroy], controller: 'registrations'
  
  namespace :admin do
    root 'dashboard#index'
    resources :events, only: [:index, :destroy] do
      collection do
        delete :bulk_destroy
      end
    end
    resources :registrations, only: [:index, :destroy] do
      collection do
        delete :bulk_destroy
        post :export_selected_csv
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
