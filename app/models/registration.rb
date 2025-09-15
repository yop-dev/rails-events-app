class Registration < ApplicationRecord
  belongs_to :event
  
  # Validations
  validates :attendee_name, presence: true
  validates :attendee_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
