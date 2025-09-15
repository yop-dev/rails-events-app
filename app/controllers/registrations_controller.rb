class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_registration, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:create]

  def create
    @registration = @event.registrations.build(registration_params)
    
    if @registration.save
      redirect_to @event, notice: 'Registration was successfully created.'
    else
      @registrations = @event.registrations.order(created_at: :desc)
      render 'events/show', status: :unprocessable_entity
    end
  end

  def edit
    @event = @registration.event
    ensure_event_owner_or_admin
  end

  def update
    @event = @registration.event
    ensure_event_owner_or_admin
    
    if @registration.update(registration_params)
      redirect_to @registration.event, notice: 'Registration was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    event = @registration.event
    ensure_event_owner_or_admin
    @registration.destroy
    redirect_to event, notice: 'Registration was successfully deleted.'
  end

  private

  def set_registration
    @registration = Registration.find(params[:id])
  end

  def set_event
    @event = Event.for_user(current_user).find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: 'Event not found or access denied.'
  end

  def ensure_event_owner_or_admin
    unless current_user.admin? || @event.user == current_user
      redirect_to events_path, alert: 'Access denied. You can only manage registrations for your own events.'
    end
  end

  def registration_params
    params.require(:registration).permit(:attendee_name, :attendee_email)
  end
end
