# spec/controllers/api/v1/admins_controller_spec.rb

# Include necessary test dependencies and configure RSpec for controller testing
require 'rails_helper'

# Describe the AdminsController, specifying it as a controller test
RSpec.describe Api::V1::AdminsController, type: :controller do
  # Include Devise test helpers for simulating admin authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    # Context for when an admin is signed in
    context 'when an admin is signed in' do
      # Create an admin using FactoryBot for testing
      let(:admin) { FactoryBot.create(:admin) }

      before do
        # Sign in the admin for this test case
        sign_in admin
      end

      it 'returns a list of admins' do
        # Send a GET request to the index action
        get :index

        # Expect an HTTP OK response
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Expect that the response contains one admin (or as per your test data)
        expect(json_response.length).to eq(1)
      end
    end
  end

  # Describe the 'GET #show' action
  describe 'GET #show' do
    # Context for when an admin is signed in
    context 'when an admin is signed in' do
      # Create an admin using FactoryBot for testing
      let(:admin) { FactoryBot.create(:admin) }

      before do
        # Sign in the admin for this test case
        sign_in admin
      end

      it 'returns details of the signed-in admin' do
        # Perform the GET request to the show action, specifying the admin's ID
        get :show, params: { id: admin.id }

        # Expect a successful response with HTTP status 200
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Expect that the response contains the admin's ID and email (or other attributes)
        expect(json_response['id']).to eq(admin.id)
        expect(json_response['email']).to eq(admin.email)
      end
    end
  end

  # Describe the 'PUT #update' action
  describe 'PUT #update' do
    # Context for when an admin is signed in
    context 'when an admin is signed in' do
      # Create an admin using FactoryBot for testing
      let(:admin) { FactoryBot.create(:admin) }

      before do
        # Sign in the admin for this test case
        sign_in admin
      end

      it 'updates the admin in JSON format' do
        # Specify the new name for the admin
        new_name = 'Updated Admin Name'

        # Send a PUT request to the update action, specifying the admin's ID and new name
        put :update, params: { id: admin.id, admin: { name: new_name } }

        # Expect an HTTP OK response
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Expect that the response contains the admin's ID and the updated name
        expect(json_response).to be_a(Hash)
        expect(json_response['id']).to eq(admin.id)
        expect(json_response['name']).to eq(new_name)

        # Verify that the admin record has been updated in the database
        admin.reload
        expect(admin.name).to eq(new_name)
      end
    end

    # Context for when no admin is signed in
    context 'when no admin is signed in' do
      it 'returns unauthorized status' do
        # Send a PUT request to the update action without authentication
        put :update, params: { id: 1, admin: { name: 'New Name' } }

        # Expect an unauthorized response status
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    # Context for when an admin is signed in
    context 'when an admin is signed in' do
      # Create an admin using FactoryBot for testing
      let(:admin) { FactoryBot.create(:admin) }

      before do
        # Sign in the admin for this test case
        sign_in admin
      end

      it 'deletes the admin' do
        # Send a DELETE request to the destroy action, specifying the admin's ID
        delete :destroy, params: { id: admin.id }

        # Expect a no content response status
        expect(response).to have_http_status(:no_content)

        # Verify that the admin record has been deleted from the database
        expect { admin.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    # Context for when no admin is signed in
    context 'when no admin is signed in' do
      it 'returns unauthorized status' do
        # Send a DELETE request to the destroy action without authentication
        delete :destroy, params: { id: 1 }

        # Expect an unauthorized response status
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
