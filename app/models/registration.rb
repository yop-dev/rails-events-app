class Registration < ApplicationRecord
  belongs_to :event
  
  # Validations
  validates :attendee_name, presence: { message: "is required" }
  validates :attendee_email, 
            presence: { message: "is required" },
            format: { 
              with: URI::MailTo::EMAIL_REGEXP, 
              message: "must be a valid email address" 
            }
end
