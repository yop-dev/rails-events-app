class Admin::EventsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :ensure_admin_role

  def index
    @events = Event.includes(:user, :registrations)
    
    # Search functionality
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @events = @events.where(
        "LOWER(name) LIKE LOWER(?) OR LOWER(location) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)", 
        search_term, search_term, search_term
      )
    end

    # Filter by user
    if params[:user_id].present?
      @events = @events.where(user_id: params[:user_id])
    end

    # Order by creation date (newest first)
    @events = @events.order(created_at: :desc)

    # Pagination (optional - can be added later)
    @events = @events.limit(50) if params[:search].blank?

    # Statistics for the admin
    @total_events = Event.count
    @total_registrations = Registration.count
    @users_with_events = User.joins(:events).distinct.count
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to admin_events_path, notice: 'Event deleted successfully.'
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_events_path, alert: 'Event not found.'
  end

  def bulk_destroy
    if params[:event_ids].present?
      Event.where(id: params[:event_ids]).destroy_all
      redirect_to admin_events_path, notice: "#{params[:event_ids].length} events deleted successfully."
    else
      redirect_to admin_events_path, alert: 'No events selected.'
    end
  end

  private

  def ensure_admin_role
    unless current_admin_user&.admin?
      redirect_to root_path, alert: 'Admin access required.'
    end
  end
end
