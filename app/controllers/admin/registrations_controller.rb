class Admin::RegistrationsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :ensure_admin_role

  def index
    @registrations = Registration.includes(:event)
    
    # Search functionality
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @registrations = @registrations.joins(:event).where(
        "LOWER(registrations.attendee_name) LIKE LOWER(?) OR LOWER(registrations.attendee_email) LIKE LOWER(?) OR LOWER(events.name) LIKE LOWER(?)", 
        search_term, search_term, search_term
      )
    end

    # Filter by event
    if params[:event_id].present?
      @registrations = @registrations.where(event_id: params[:event_id])
    end

    # Order by creation date (newest first)
    @registrations = @registrations.order(created_at: :desc)

    # Pagination (optional - can be added later)
    @registrations = @registrations.limit(100) if params[:search].blank?

    # Statistics for the admin
    @total_registrations = Registration.count
    @unique_attendees = Registration.distinct.count(:attendee_email)
    @events_with_registrations = Event.joins(:registrations).distinct.count
    @all_events = Event.includes(:registrations).order(:name)

    respond_to do |format|
      format.html
      format.csv { export_to_csv }
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy
    redirect_to admin_registrations_path, notice: 'Registration deleted successfully.'
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_registrations_path, alert: 'Registration not found.'
  end

  def bulk_destroy
    if params[:registration_ids].present?
      Registration.where(id: params[:registration_ids]).destroy_all
      redirect_to admin_registrations_path, notice: "#{params[:registration_ids].length} registrations deleted successfully."
    else
      redirect_to admin_registrations_path, alert: 'No registrations selected.'
    end
  end

  def export_selected_csv
    Rails.logger.debug "Export selected CSV called with params: #{params.inspect}"
    Rails.logger.debug "Registration IDs: #{params[:registration_ids]}"
    
    if params[:registration_ids].present?
      registrations = Registration.includes(:event).where(id: params[:registration_ids]).order(created_at: :desc)
      Rails.logger.debug "Found #{registrations.count} registrations to export"
      
      if registrations.any?
        export_registrations_to_csv(registrations, "selected_registrations_export_#{Date.current.strftime('%Y%m%d')}.csv")
      else
        redirect_to admin_registrations_path, alert: 'No valid registrations found for export.'
      end
    else
      Rails.logger.debug "No registration IDs provided"
      redirect_to admin_registrations_path, alert: 'No registrations selected for export.'
    end
  rescue => e
    Rails.logger.error "Error exporting CSV: #{e.message}"
    redirect_to admin_registrations_path, alert: 'An error occurred while exporting the CSV file.'
  end

  private

  def ensure_admin_role
    unless current_admin_user&.admin?
      redirect_to root_path, alert: 'Admin access required.'
    end
  end

  def export_to_csv
    filename = "registrations_export_#{Date.current.strftime('%Y%m%d')}.csv"
    export_registrations_to_csv(@registrations, filename)
  end

  def export_registrations_to_csv(registrations, filename)
    Rails.logger.debug "Generating CSV for #{registrations.count} registrations"
    
    # Generate CSV content manually without requiring CSV gem
    csv_content = []
    csv_content << "Event Name,Event Date,Event Location,Attendee Name,Attendee Email,Registration Date,Event Organizer"
    
    registrations.each do |registration|
      row = [
        registration.event.name,
        registration.event.date.strftime('%Y-%m-%d %H:%M'),
        registration.event.location,
        registration.attendee_name,
        registration.attendee_email,
        registration.created_at.strftime('%Y-%m-%d %H:%M'),
        registration.event.user.email
      ]
      # Escape any commas or quotes in the data
      escaped_row = row.map { |field| escape_csv_field(field.to_s) }
      csv_content << escaped_row.join(',')
    end

    csv_data = csv_content.join("\n")
    Rails.logger.debug "Generated CSV with #{csv_data.length} characters, filename: #{filename}"
    
    send_data csv_data, 
              filename: filename, 
              type: 'text/csv', 
              disposition: 'attachment'
  end
  
  def escape_csv_field(field)
    # If field contains comma, quote, or newline, wrap in quotes and escape internal quotes
    if field.include?(',') || field.include?('"') || field.include?("\n")
      '"' + field.gsub('"', '""') + '"'
    else
      field
    end
  end
end
