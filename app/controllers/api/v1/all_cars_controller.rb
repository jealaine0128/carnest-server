# app/controllers/api/v1/all_cars_controller.rb

module Api
  module V1
    class AllCarsController < ApplicationController
      # GET /api/v1/all_cars
      def index
        # Retrieve all cars from the database
        @cars = Car.all
        # Render a JSON response with the list of cars
        render json: @cars
      end

      # Show details of a specific car, including its operator
      def show
        begin
          # Find the car by its ID and eager-load the associated operator
          @car = Car.includes(:operator).find(params[:id])
        rescue ActiveRecord::RecordNotFound
          # If the car is not found, respond with a "not found" error
          render json: { error: 'Car not found' }, status: :not_found
        else
          # Render a JSON response with the car details, including its operator
          render json: @car, include: :operator
        end
      end
    end
  end
end
