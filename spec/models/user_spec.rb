# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
  end

  describe 'validations' do
    it 'validates the presence of required attributes' do
      user = User.new
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many Bookings' do
      association = User.reflect_on_association(:bookings)
      expect(association.macro).to eq(:has_many)
    end
 
  end

end
