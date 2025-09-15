class Admins::RegistrationsController < Devise::RegistrationsController
  ADMIN_SECRET_CODE = "ADMIN2025SECRET"

  skip_before_action :require_no_authentication, only: [:new, :create]

  def new
    build_resource({})
    render 'admins/registrations/new'
  end

  def create
    # Check secret code first
    if params[:admin_user][:secret_code] != ADMIN_SECRET_CODE
      build_resource(sign_up_params)
      resource.errors.add(:secret_code, "Invalid admin secret code")
      render :new, status: :unprocessable_entity
      return
    end

    # Create the admin user
    build_resource(sign_up_params.except(:secret_code))
    resource.role = 1  # Set as admin

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        # Explicit redirect to admin dashboard
        redirect_to admin_root_path, notice: 'Admin account created successfully!'
        return
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to admin_root_path
        return
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
