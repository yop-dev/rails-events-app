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
  namespace :admin do
    root 'dashboard#index'
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
