# spec/models/car_spec.rb
require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'validations' do
    it 'validates the presence of required attributes' do
      car = FactoryBot.build(:car) # Use your factory to create a car instance
      expect(car).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an operator' do
      association = Car.reflect_on_association(:operator)
      expect(association.macro).to eq(:belongs_to)
    end
  end

end
