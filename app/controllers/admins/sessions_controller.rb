class Admins::SessionsController < Devise::SessionsController
  # CRITICAL: No before_action :admin_required here!
  # CRITICAL: No before_action :authenticate_user! here!

  protected

  def after_sign_in_path_for(resource)
    admin_root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
