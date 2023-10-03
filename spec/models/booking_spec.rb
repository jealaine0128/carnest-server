# spec/models/booking_spec.rb
require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'validations' do
    it 'validates the presence of required attributes' do
      booking = FactoryBot.build(:booking) # Use your factory to create a valid booking instance
      expect(booking).to be_valid
      # Add more validation checks for other attributes as needed
    end
  end

  describe 'associations' do
    it 'belongs to an operator' do
      association = Booking.reflect_on_association(:operator)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a user' do
      association = Booking.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

end
