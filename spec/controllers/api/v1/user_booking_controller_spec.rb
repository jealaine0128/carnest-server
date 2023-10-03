# spec/controllers/api/v1/user_booking_controller_spec.rb
require 'rails_helper'

# Describe the UserBookingController and specify it as a controller test
RSpec.describe Api::V1::UserBookingController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers

  # Describe the 'GET #index' action
  describe 'GET #index' do
    context 'when a user is signed in' do
      it 'returns a list of user bookings' do
        # Create a user using FactoryBot
        user = FactoryBot.create(:user)

        # Sign in as the user before each test
        sign_in user

        # Create some bookings for the user using FactoryBot
        FactoryBot.create_list(:booking, 3, user: user)

        # Send a GET request to the index action
        get :index

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is an array with a length of 3 (assuming 3 bookings were created)
        expect(json_response.length).to eq(3)
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

      # Create an operator and a car using FactoryBot
      let(:operator) { FactoryBot.create(:operator) }
      let(:car) { FactoryBot.create(:car, operator: operator) }

      # Define booking parameters for testing
      let(:booking_params) do
        {
          operator_id: operator.id,
          user_id: user.id,
          car_id: car.id,
          pickup_date: Faker::Date.forward(days: 7).strftime("%Y-%m-%d"),
          pickup_time: Faker::Time.forward(days: 7).strftime("%H:%M:%S"),
          duration: Faker::Number.between(from: 1, to: 7),
          return_date: Faker::Date.forward(days: 14).strftime("%Y-%m-%d"),
          total_price: Faker::Number.between(from: 100, to: 500),
          status: Faker::Number.between(from: 1, to: 2)
        }
      end

      # Sign in as the user before each test
      before do
        sign_in user
      end

      it 'creates a new booking' do
        # Expect that creating a booking will change the total count of bookings by 1
        expect do
          post :create, params: { booking: booking_params }
        end.to change(Booking, :count).by(1)

        # Expect a created response (HTTP status 201)
        expect(response).to have_http_status(:created)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and if the 'duration' matches the booking parameters
        expect(json_response).to be_a(Hash)
        expect(json_response['duration']).to eq(booking_params[:duration])
      end

      it 'returns an error if user has insufficient balance' do
        # Set the total_price to an amount higher than the user's balance
        booking_params[:total_price] = 500000.0

        # Send a POST request to create a booking with insufficient balance
        post :create, params: { booking: booking_params }

        # Expect an unprocessable entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and contains an 'error' message
        expect(json_response).to be_a(Hash)
        expect(json_response['error']).to eq('Insufficient balance to make the booking')
      end
    end

    context 'when no user is signed in' do
      it 'returns unauthorized status' do
        # Send a POST request to create a booking without signing in
        post :create

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    context 'when a user is signed in' do
      # Create a user using FactoryBot
      let(:user) { FactoryBot.create(:user) }

      # Create a booking for the user using FactoryBot
      let(:booking) { FactoryBot.create(:booking, user: user) }

      # Sign in as the user before each test
      before do
        sign_in user
      end

      it 'cancels the booking and refunds the user' do
        # Set the initial_user_balance to the user's current money balance
        initial_user_balance = user.money

        # Create the booking and ensure its status is either 1 or 2
        booking
        expect([1, 2]).to include(booking.status)

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and contains a 'message' indicating successful cancellation
        expect(json_response).to be_a(Hash)
        expect(json_response['message']).to eq('Booking successfully canceled and refunded')

        # Reload the user object from the database
        user.reload

        # Verify that the user's money is refunded by checking the balance
        expect(user.money).to eq(initial_user_balance + booking.total_price)

        # Verify that the booking's status is updated to canceled (status 0)
        expect(booking.reload.status).to eq(0)
      end
    end

    context 'when booking cancellation fails' do
      # Create a user using FactoryBot
      let(:user) { FactoryBot.create(:user) }

      # Create a booking for the user using FactoryBot
      let(:booking) { FactoryBot.create(:booking, user: user) }

      # Sign in as the user before each test
      before do
        sign_in user
      end

      it 'returns an error message' do
        # Stub the update method to simulate a failure in booking cancellation
        allow_any_instance_of(Booking).to receive(:update).and_return(false)

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect an unprocessable entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and contains an 'error' message
        expect(json_response).to be_a(Hash)
        expect(json_response['error']).to eq('Unable to cancel booking')
      end

      it 'returns an error if refunding the user fails' do
        # Stub the update method to simulate successful booking cancellation
        allow_any_instance_of(Booking).to receive(:update).and_return(true)

        # Stub the save method of the user to simulate a failure in refunding
        allow_any_instance_of(User).to receive(:save).and_return(false)

        # Send a DELETE request to cancel the booking
        delete :destroy, params: { id: booking.id }

        # Expect an unprocessable entity response (HTTP status 422)
        expect(response).to have_http_status(:unprocessable_entity)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the response is a Hash and contains an 'error' message
        expect(json_response).to be_a(Hash)
        expect(json_response['error']).to eq('Failed to refund the user')
      end
    end

    context 'when no user is signed in' do
      it 'returns unauthorized status' do
        # Send a DELETE request to cancel a booking without signing in
        delete :destroy, params: { id: 1 } # Pass a valid booking ID

        # Expect an unauthorized response (HTTP status 401)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
