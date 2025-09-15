class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :events, dependent: :destroy

  # Define user roles (simple approach)
  def admin?
    role == 1
  end

  def user?
    role == 0 || role.nil?
  end

  # Set default role
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= 0  # Default to regular user
  end
end
