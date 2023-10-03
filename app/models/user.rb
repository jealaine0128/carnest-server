# app/models/user.rb

class User < ApplicationRecord
  # Include Devise module for JWT authentication and token revocation strategies
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Configure Devise for authentication and user-related functionality
  devise :database_authenticatable,   # Allow email/password authentication
         :registerable,              # Enable registration functionality
         :recoverable,               # Enable password recovery/reset
         :validatable,               # Add email and password validations
         :jwt_authenticatable,       # Enable JWT-based authentication
         jwt_revocation_strategy: self # Specify JWT token revocation strategy

  # Define associations
  has_many :bookings, dependent: :destroy # A user can have many bookings
end
