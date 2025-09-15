class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :location, presence: true
  # description is optional, no validation needed
  
  # Scopes
  scope :for_user, ->(user) { user.admin? ? all : where(user: user) }
end
