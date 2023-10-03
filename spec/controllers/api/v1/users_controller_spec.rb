# spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

# Describe the UsersController and specify it as a controller test
RSpec.describe Api::V1::UsersController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    context 'when a user is signed in' do
      it 'returns the current user in JSON format' do
        # Create a user using FactoryBot
        user = FactoryBot.create(:user)

        # Sign in as the user before each test
        sign_in user

        # Send a GET request to the index action
        get :index

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and if the 'id' matches the user's ID
        expect(json_response).to be_a(Hash)
        expect(json_response['id']).to eq(user.id)
      end
    end

    context 'when no user is signed in' do
      it 'returns unauthorized status' do
        # Send a GET request to the index action without signing in
        get :index

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'POST #create' action
  describe 'POST #create' do
    context 'when a user is signed in' do
      # Create a user using FactoryBot
      let(:user) { FactoryBot.create(:user) }

      # Sign in as the user before each test
      before { sign_in user }

      it 'adds money to the current user' do
        # Get the initial balance of the user
        initial_balance = user.money

        # Define the amount of money to add
        money_to_add = 100

        # Send a POST request to add money to the user's account
        post :create, params: { user: { money: money_to_add } }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and if the 'money' matches the updated balance
        expect(json_response).to be_a(Hash)
        expect(json_response['money']).to eq(initial_balance + money_to_add)

        # Verify that the user's money balance has been updated in the database
        user.reload
        expect(user.money).to eq(initial_balance + money_to_add)
      end
    end

    context 'when no user is signed in' do
      it 'returns unauthorized status' do
        # Send a POST request to add money to a user's account without signing in
        post :create, params: { user: { money: 100 } }

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'PUT #update' action
  describe 'PUT #update' do
    context 'when a user is signed in' do
      # Create a user using FactoryBot
      let(:user) { FactoryBot.create(:user) }

      # Sign in as the user before each test
      before { sign_in user }

      it 'updates the user in JSON format' do
        # Define a new name for the user
        new_name = 'Updated User Name'

        # Send a PUT request to update the user's name
        put :update, params: { id: user.id, user: { name: new_name } }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and if the 'id' and 'name' match the updated values
        expect(json_response).to be_a(Hash)
        expect(json_response['id']).to eq(user.id)
        expect(json_response['name']).to eq(new_name)

        # Reload the user object from the database
        user.reload

        # Verify that the user's name has been updated in the database
        expect(user.name).to eq(new_name)
      end

      it 'returns an error if user update fails' do
        # Stub the update method to simulate a failure in user update
        allow_any_instance_of(User).to receive(:update).and_return(false)

        # Send a PUT request to update the user's name with invalid parameters
        put :update, params: { id: user.id, user: { name: 'New Name' } }

        # Expect an unprocessable entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when no user is signed in' do
      it 'returns unauthorized status' do
        # Send a PUT request to update a user's name without signing in
        put :update, params: { id: 1, user: { name: 'New Name' } }

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
