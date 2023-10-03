# spec/controllers/api/v1/all_cars_controller_spec.rb

# Include necessary test dependencies and configure RSpec for controller testing
require 'rails_helper'

# Describe the AllCarsController, specifying it as a controller test
RSpec.describe Api::V1::AllCarsController, type: :controller do
  # Describe the 'GET #index' action
  describe 'GET #index' do
    it 'returns a list of cars in JSON format' do
      # Create some test cars using FactoryBot
      FactoryBot.create_list(:car, 3)

      # Send a GET request to the index action
      get :index

      # Expect a successful response (HTTP status 200)
      expect(response).to have_http_status(:ok)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response is an array of cars
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(3)
    end
  end

  # Describe the 'GET #show' action
  describe 'GET #show' do
    it 'returns a single car in JSON format' do
      # Create a test car using FactoryBot
      car = FactoryBot.create(:car)

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

    it 'returns a not found response for an invalid car ID' do
      # Send a GET request to the show action with an invalid car ID
      get :show, params: { id: 999 }

      # Expect a not found response (HTTP status 404)
      expect(response).to have_http_status(:not_found)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Check if the response contains an error message
      expect(json_response['error']).to eq('Car not found')
    end
  end
end
