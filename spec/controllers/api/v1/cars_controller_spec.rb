# spec/controllers/api/v1/cars_controller_spec.rb
require 'rails_helper'

# Describe the CarsController and specify it as a controller test
RSpec.describe Api::V1::CarsController, type: :controller do
  # Include Devise test helpers for authentication
  include Devise::Test::ControllerHelpers
  
  # Create instances of operator, car, user, and booking using FactoryBot
  let(:operator) { FactoryBot.create(:operator) }
  let(:car) { FactoryBot.create(:car, operator: operator) }
  let(:user) { FactoryBot.create(:user) }
  let(:booking) { FactoryBot.create(:booking, operator: operator, user: user) }

  # Sign in an operator before each example
  before do
    sign_in operator
  end

  # Describe the 'GET #index' action
  describe 'GET #index' do
    it 'returns a list of cars associated with the operator' do
      # Create a list of 3 cars associated with the operator using FactoryBot
      FactoryBot.create_list(:car, 3, operator: operator)

      # Send a GET request to the index action
      get :index

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is an array of cars
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(3) # Include the manually created car
    end
  end

  # Describe the 'GET #show' action
  describe 'GET #show' do
    it 'returns the details of a car' do
      # Send a GET request to the show action with the car's ID
      get :show, params: { id: car.id }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is a hash representing a car
      expect(json_response).to be_a(Hash)
      expect(json_response['id']).to eq(car.id)
    end
  end

  # Describe the 'POST #create' action
  describe 'POST #create' do
    it 'creates a new car' do
      # Define car parameters using FactoryBot attributes_for
      car_params = FactoryBot.attributes_for(:car, operator_id: operator.id)

      # Send a POST request to create a new car
      post :create, params: { car: car_params }

      # Expect a successful response (HTTP status 201 - Created)
      expect(response).to have_http_status(:created)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response contains the correct car details
      expect(json_response['car_brand']).to eq(car_params[:car_brand])
      expect(json_response['operator_id']).to eq(operator.id)
    end
  end

  # Describe the 'PATCH #update' action
  describe 'PATCH #update' do
    it 'updates the details of a car' do
      # Define a new car brand for the update
      new_car_brand = 'Updated Car Brand'

      # Send a PATCH request to update the car's car_brand
      patch :update, params: { id: car.id, car: { car_brand: new_car_brand } }

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the car's car_brand has been updated
      expect(json_response['car_brand']).to eq(new_car_brand)
    end

    context 'when car is reserved and reserved flag is set to false' do
      before do
        # Set the car as reserved and associate it with a booking
        car.update(reserved: true)
        booking.update(car_info: car, car_id: car.id)
      end

      it 'updates booking status to 0 and refunds user money' do
        # Get the initial user money balance
        initial_user_money = booking.user.money

        # Send a PATCH request to update the car's reserved flag to false
        patch :update, params: { id: car.id, car: { reserved: false } }

        # Expect a successful response (HTTP status 200)
        expect(response).to have_http_status(:ok)

        # Parse the JSON response
        json_response = JSON.parse(response.body)

        # Check if the car's reserved flag has been updated to false
        expect(json_response['reserved']).to eq(false)

        # Check that the booking status is updated to 0
        booking.reload
        expect(booking.status).to eq(0)

        # Check that the user's money is refunded
        expect(booking.user.money).to eq(initial_user_money + booking.total_price)

        # Check that the car's reserved status is updated to false
        expect(car.reload.reserved).to eq(false)
      end
    end

    it 'returns an error if car update fails' do
      # Stub the update method to simulate a failure in car update
      allow_any_instance_of(Car).to receive(:update).and_return(false)

      # Send a PATCH request to update the car's car_brand (with invalid data)
      patch :update, params: { id: car.id, car: { car_brand: 'Invalid Brand' } }

      # Expect an unprocessable_entity response (HTTP status 422)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  # Describe the 'DELETE #destroy' action
  describe 'DELETE #destroy' do
    it 'deletes a car' do
      # Create the car using FactoryBot
      car

      # Send a DELETE request to delete the car
      delete :destroy, params: { id: car.id }

      # Expect a no_content response (HTTP status 204)
      expect(response).to have_http_status(:no_content)

      # Check that the car is no longer found in the database
      expect { Car.find(car.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
