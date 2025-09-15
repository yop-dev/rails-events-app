class EventsController < ApplicationController
  before_action :authenticate_any_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner_or_admin, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.for_user(current_authenticated_user).includes(:registrations).order(date: :asc)
  end

  def show
    @registration = Registration.new
    @registrations = @event.registrations.order(created_at: :desc)
  end

  def new
    @event = current_authenticated_user.events.build
  end

  def create
    @event = current_authenticated_user.events.build(event_params)
    
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  private

  def set_event
    @event = Event.for_user(current_authenticated_user).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: 'Event not found or access denied.'
  end

  def ensure_owner_or_admin
    unless current_authenticated_user.admin? || @event.user == current_authenticated_user
      redirect_to events_path, alert: 'Access denied. You can only manage your own events.'
    end
  end
  
  def authenticate_any_user!
    unless user_signed_in? || admin_user_signed_in?
      redirect_to root_path, alert: 'Please sign in to continue.'
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :location, :description)
  end
end
