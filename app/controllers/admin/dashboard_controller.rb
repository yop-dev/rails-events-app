class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :ensure_admin_role

  def index
    @current_admin = current_admin_user
  end

  private

  def ensure_admin_role
    unless current_admin_user&.admin?
      redirect_to root_path, alert: 'Admin access required.'
    end
  end
end
