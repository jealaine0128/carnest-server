# spec/models/admin_spec.rb
require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "has a valid factory" do
    admin = FactoryBot.build(:admin)
    expect(admin).to be_valid
  end

  describe "validations" do
    it "validates the presence of email" do
      admin = Admin.new
      expect(admin).not_to be_valid
      expect(admin.errors[:email]).to include("can't be blank")
    end

    it "validates the presence of password" do
      admin = Admin.new
      expect(admin).not_to be_valid
      expect(admin.errors[:password]).to include("can't be blank")
    end

    it "validates the uniqueness of email" do
      FactoryBot.create(:admin, email: "test@example.com")
      admin = FactoryBot.build(:admin, email: "test@example.com")
      expect(admin).not_to be_valid
      expect(admin.errors[:email]).to include("has already been taken")
    end
  end
end
