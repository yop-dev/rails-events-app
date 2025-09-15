class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    resource.role = 0  # Set as regular user
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource), notice: 'Account created successfully!'
      else
        set_flash_message! :notice, "signed_up_but_#{resource.inactive_message}".to_sym if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to root_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end
