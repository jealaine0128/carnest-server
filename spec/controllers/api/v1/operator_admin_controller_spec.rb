# spec/controllers/api/v1/operator_admin_controller_spec.rb
require 'rails_helper'

# Describe the OperatorAdminController and specify it as a controller test
RSpec.describe Api::V1::OperatorAdminController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    context 'when an admin is signed in' do
      let(:admin) { FactoryBot.create(:admin) }

      before do
        sign_in admin
      end

      it 'returns a list of operators' do
        # Create two operators using FactoryBot
        operator1 = FactoryBot.create(:operator)
        operator2 = FactoryBot.create(:operator)
        
        # Send a GET request to the index action
        get :index

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response contains two operators (assuming you have 2 operators created)
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
      let(:admin) { FactoryBot.create(:admin) }
      let(:operator) { FactoryBot.create(:operator) }

      before do
        sign_in admin
      end

      it 'returns the operator with bookings' do
        # Send a GET request to the show action with the operator's ID
        get :show, params: { id: operator.id }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response contains the operator's name
        expect(json_response['name']).to eq(operator.name)
      end
    end
  end

  # Describe the 'PATCH #update' action
  describe 'PATCH #update' do
    context 'when an admin is signed in' do
      let(:admin) { FactoryBot.create(:admin) }
      let(:operator) { FactoryBot.create(:operator) }
      let(:updated_attributes) { { name: 'New Name' } }

      before do
        sign_in admin
      end

      it 'updates the operator' do
        # Send a PATCH request to update the operator's name
        patch :update, params: { id: operator.id, name: updated_attributes[:name] }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Reload the operator record from the database
        operator.reload

        # Check if the operator's name has been updated
        expect(operator.name).to eq(updated_attributes[:name])
      end
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    context 'when an admin is signed in' do
      let(:admin) { FactoryBot.create(:admin) }
      let(:operator) { FactoryBot.create(:operator) }

      before do
        sign_in admin
      end

      it 'deletes the operator' do
        # Expect that the Operator count doesn't change after deleting
        expect {
          delete :destroy, params: { id: operator.id }
        }.to change(Operator, :count).by(0)
        
        # Expect a no_content response (HTTP status 204)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
