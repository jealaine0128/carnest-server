# spec/controllers/api/v1/bookings_controller_spec.rb
require 'rails_helper'

# Describe the BookingsController and specify it as a controller test
RSpec.describe Api::V1::BookingsController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Create instances of admin, user, operator, and booking using FactoryBot
  let(:admin) { FactoryBot.create(:admin) }
  let(:user) { FactoryBot.create(:user) }
  let(:operator) { FactoryBot.create(:operator) }
  let(:booking) { FactoryBot.create(:booking, operator: operator, user: user) }

  # Sign in an admin before each example
  before do
    sign_in admin
  end

  # Describe the 'GET #index' action
  describe 'GET #index' do
    it 'returns a list of bookings' do
      # Create a list of 3 bookings using FactoryBot
      FactoryBot.create_list(:booking, 3)

      # Send a GET request to the index action
      get :index

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is an array of bookings
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(3) # Include the manually created booking
    end
  end

  # Describe the 'GET #show' action
  describe 'GET #show' do
    it 'returns the details of a booking' do
      # Send a GET request to the show action with the booking's ID
      get :show, params: { id: booking.id }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is a hash representing a booking
      expect(json_response).to be_a(Hash)
      expect(json_response['id']).to eq(booking.id)
    end
  end

  # Describe the 'PATCH #update' action
  describe 'PATCH #update' do
    it 'updates the status of a booking' do
      # Send a PATCH request to update the booking's status to 2
      patch :update, params: { id: booking.id, status: 2 }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the booking's status has been updated to 2
      expect(json_response['status']).to eq(2)
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    context 'when booking is canceled successfully' do
      it 'cancels a booking and refunds the user' do
        # Create the booking
        booking

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response contains a success message
        expect(json_response['message']).to eq('Booking successfully canceled and refunded')
      end
    end

    context 'when booking cancellation fails' do
      it 'returns an error message' do
        # Stubbing the update method to simulate a failure in booking cancellation
        allow_any_instance_of(Booking).to receive(:update).and_return(false)

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect an unprocessable_entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response contains an error message
        expect(json_response['error']).to eq('Unable to cancel booking')
      end

      it 'returns an error if refunding the user fails' do
        # Stubbing the update method to simulate a successful cancellation
        allow_any_instance_of(Booking).to receive(:update).and_return(true)

        # Stubbing the save method of @booking.user to simulate a failure
        allow_any_instance_of(User).to receive(:save).and_return(false)

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect an unprocessable_entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response contains an error message
        expect(json_response['error']).to eq('Failed to refund the user')
      end
    end
  end
end
