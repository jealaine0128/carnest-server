# spec/models/operator_spec.rb
require 'rails_helper'

RSpec.describe Operator, type: :model do
  describe 'validations' do
    it 'validates the presence of required attributes' do
      operator = FactoryBot.build(:operator) # Use your factory to create an operator instance
      expect(operator).to be_valid
    end
  end

  describe 'associations' do
    it 'has many cars' do
      association = Operator.reflect_on_association(:cars)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many bookings' do
      association = Operator.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)
    end
  end

end
