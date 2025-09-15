class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :ensure_admin_role

  def index
    @current_admin = current_admin_user
    @total_events = Event.count
    @total_users = User.where(role: [0, nil]).count
    @total_admins = User.where(role: 1).count
    @total_registrations = Registration.count
    @recent_events = Event.includes(:user, :registrations).order(created_at: :desc).limit(5)
  end

  private

  def ensure_admin_role
    unless current_admin_user&.admin?
      redirect_to root_path, alert: 'Admin access required.'
    end
  end
end
