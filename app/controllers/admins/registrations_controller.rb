class Admins::RegistrationsController < Devise::RegistrationsController
  # Use environment variable with fallback for development/assessment
  ADMIN_SECRET_CODE = ENV.fetch('ADMIN_SECRET_CODE', 'ADMIN2025SECRET')

  def create
    # Validate secret code
    secret_code = params.dig(:admin_user, :secret_code)
    
    build_resource(sign_up_params.except(:secret_code))
    
    if secret_code != ADMIN_SECRET_CODE
      resource.errors.add(:secret_code, "Invalid admin secret code")
      clean_up_passwords resource
      set_minimum_password_length
      render :new, status: :unprocessable_entity
      return
    end

    # Set as admin
    resource.role = 1
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        redirect_to admin_root_path, notice: 'Admin account created successfully!'
      else
        set_flash_message! :notice, "signed_up_but_#{resource.inactive_message}".to_sym if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to admin_root_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:admin_user).permit(:email, :password, :password_confirmation, :secret_code)
  end

  def after_sign_up_path_for(resource)
    admin_root_path
  end
end
