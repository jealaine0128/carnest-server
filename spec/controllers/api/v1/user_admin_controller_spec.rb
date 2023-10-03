# spec/controllers/api/v1/user_admin_controller_spec.rb
require 'rails_helper'

# Describe the UserAdminController and specify it as a controller test
RSpec.describe Api::V1::UserAdminController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    context 'when an admin is signed in' do
      # Create an admin using FactoryBot
      let(:admin) { FactoryBot.create(:admin) }

      # Sign in as the admin before each test
      before do
        sign_in admin
      end

      it 'returns a list of users' do
        # Create two users using FactoryBot
        user1 = FactoryBot.create(:user)
        user2 = FactoryBot.create(:user)

        # Send a GET request to the index action
        get :index

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is an array with a length of 2 (assuming 2 users were created)
        expect(json_response.length).to eq(2)
      end
    end

    context 'when no admin is signed in' do
      it 'returns unauthorized status' do
        # Send a GET request to the index action without signing in
        get :index

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'GET #show' action
  describe 'GET #show' do
    context 'when an admin is signed in' do
      # Create an admin and a user using FactoryBot
      let(:admin) { FactoryBot.create(:admin) }
      let(:user) { FactoryBot.create(:user) }

      # Sign in as the admin before each test
      before do
        sign_in admin
      end

      it 'returns the user with bookings' do
        # Send a GET request to the show action with the user's ID
        get :show, params: { id: user.id }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the 'name' in the response matches the user's name
        expect(json_response['name']).to eq(user.name)
      end
    end
  end

  # Describe the 'PATCH #update' action
  describe 'PATCH #update' do
    context 'when an admin is signed in' do
      # Create an admin and a user using FactoryBot
      let(:admin) { FactoryBot.create(:admin) }
      let(:user) { FactoryBot.create(:user) }

      # Define updated attributes for the user
      let(:updated_attributes) { { name: 'New Name' } }

      # Sign in as the admin before each test
      before do
        sign_in admin
      end

      it 'updates the user' do
        # Send a PATCH request to update the user's name
        patch :update, params: { id: user.id, name: updated_attributes[:name] }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Reload the user object from the database to verify the update
        user.reload

        # Check if the user's name in the database matches the new name
        expect(user.name).to eq(updated_attributes[:name])
      end
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    context 'when an admin is signed in' do
      # Create an admin and a user using FactoryBot
      let(:admin) { FactoryBot.create(:admin) }
      let(:user) { FactoryBot.create(:user) }

      # Sign in as the admin before each test
      before do
        sign_in admin
      end

      it 'deletes the user' do
        # Expect that deleting the user will not change the total count of users
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(0)

        # Expect a no content response (HTTP status 204)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
