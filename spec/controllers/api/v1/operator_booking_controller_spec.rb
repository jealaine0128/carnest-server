# spec/controllers/api/v1/operator_booking_controller_spec.rb
require 'rails_helper'

# Describe the OperatorBookingController and specify it as a controller test
RSpec.describe Api::V1::OperatorBookingController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Create instances of operator, user, and booking using FactoryBot
  let(:operator) { FactoryBot.create(:operator) }
  let(:user) { FactoryBot.create(:user) }
  let(:booking) { FactoryBot.create(:booking, operator: operator, user: user) }

  # Sign in the operator before each test
  before do
    sign_in operator
  end

  # Describe the 'GET #index' action
  describe 'GET #index' do
    it 'returns a list of operator bookings' do
      # Send a GET request to the index action
      get :index

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is an array
      expect(json_response).to be_an(Array)
    end
  end

  # Describe the 'PUT #update' action
  describe 'PUT #update' do
    it 'updates the booking status to confirmed' do
      # Send a PUT request to update the booking status
      put :update, params: { id: booking.id }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the booking status is updated to 3 (confirmed)
      expect(json_response['status']).to eq(3)
    end

    it 'calculates the fees and updates operator balance' do
      # Get the initial operator balance
      initial_operator_balance = operator.money

      # Send a PUT request to update the booking status
      put :update, params: { id: booking.id }

      # Reload the operator record from the database
      operator.reload

      # Calculate the expected operator balance after deducting the fee
      fee = booking.total_price * 0.10
      expected_operator_balance = (initial_operator_balance + booking.total_price - fee).to_i

      # Verify that the operator's balance has been updated correctly with a tolerance of 0.01
      expect(operator.money).to eq(expected_operator_balance.to_i)

      # Ensure that the booking status is updated to 3 (confirmed)
      expect(booking.reload.status).to eq(3)
    end

    it 'returns an error if booking update fails' do
      # Stub the update method of Booking to simulate a failure
      allow_any_instance_of(Booking).to receive(:update).and_return(false)

      # Send a PUT request to update the booking status
      put :update, params: { id: booking.id }

      # Expect an unprocessable_entity response (HTTP status 422)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    it 'cancels the booking and refunds the user' do
      # Get the initial user balance
      initial_user_balance = user.money

      # Send a DELETE request to cancel the booking
      delete :destroy, params: { id: booking.id }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response contains a 'message' key
      expect(json_response).to have_key('message')

      # Reload the user record from the database
      user.reload

      # Verify that the user's money is refunded
      expect(user.money).to eq(initial_user_balance + booking.total_price)

      # Verify that the booking status is updated to 0 (canceled)
      expect(booking.reload.status).to eq(0)
    end

    it 'returns an error if booking cancellation fails' do
      # Stub the update method of Booking to simulate a failure
      allow_any_instance_of(Booking).to receive(:update).and_return(false)

      # Send a DELETE request to cancel the booking
      delete :destroy, params: { id: booking.id }

      # Expect an unprocessable_entity response (HTTP status 422)
      expect(response).to have_http_status(:unprocessable_entity)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response contains an 'error' key
      expect(json_response).to have_key('error')
    end
  end
end
