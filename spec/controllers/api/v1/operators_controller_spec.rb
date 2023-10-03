# spec/controllers/api/v1/operators_controller_spec.rb
require 'rails_helper'

# Describe the OperatorsController and specify it as a controller test
RSpec.describe Api::V1::OperatorsController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    context 'when an operator is signed in' do
      it 'returns the current operator in JSON format' do
        # Create an operator using FactoryBot
        operator = FactoryBot.create(:operator)

        # Sign in as the operator
        sign_in operator

        # Send a GET request to the index action
        get :index

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a JSON hash
        expect(json_response).to be_a(Hash)

        # Check if the 'id' in the response matches the operator's ID
        expect(json_response['id']).to eq(operator.id)
      end
    end

    context 'when no operator is signed in' do
      it 'returns unauthorized status' do
        # Send a GET request to the index action without signing in
        get :index

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'PUT #update' action
  describe 'PUT #update' do
    context 'when an operator is signed in' do
      # Create an operator using FactoryBot
      let(:operator) { FactoryBot.create(:operator) }

      # Sign in as the operator before each test
      before do
        sign_in operator
      end

      it 'updates the operator and returns the updated operator in JSON format' do
        # Define a new name for the operator
        new_name = 'Updated Operator Name'

        # Send a PUT request to update the operator's name
        put :update, params: { id: operator.id, operator: { name: new_name } }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the 'name' in the response matches the new name
        expect(json_response['name']).to eq(new_name)

        # Reload the operator object from the database to verify the update
        operator.reload

        # Check if the operator's name in the database matches the new name
        expect(operator.name).to eq(new_name)
      end

      it 'returns unprocessable entity status if update fails' do
        # Simulate a failure by providing invalid parameters (empty email)
        put :update, params: { id: operator.id, operator: { email: '' } }

        # Expect an unprocessable entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when no operator is signed in' do
      it 'returns unauthorized status' do
        # Send a PUT request to update an operator without signing in
        put :update, params: { id: 1, operator: { name: 'New Name' } }

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
