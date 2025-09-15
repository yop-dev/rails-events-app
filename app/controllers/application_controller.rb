class ApplicationController < ActionController::Base
  # CRITICAL: Do NOT have this line globally:
  # before_action :authenticate_user!
  # before_action :admin_required

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for(resource)
    # This will be overridden by the specific admin sessions controller
    # for admin users, so this only handles regular users
    root_path
  end

  def after_sign_up_path_for(resource)
    # This will be overridden by the specific admin registrations controller
    # for admin users, so this only handles regular users  
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :secret_code])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  # This method should ONLY be called by controllers that need admin protection
  def admin_required
    redirect_to root_path, alert: 'Admin access required.' unless current_user&.admin?
  end
  
  # Helper method to get the current user regardless of authentication scope
  def current_authenticated_user
    current_admin_user || current_user
  end
  
  # Make it available to views
  helper_method :current_authenticated_user
end
