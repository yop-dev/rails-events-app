class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end
