# app/controllers/api/v1/cars_controller.rb

module Api
  module V1
    class CarsController < ApplicationController
      # Ensure that only authenticated operators can access these actions
      before_action :authenticate_operator!
      # Set the car instance variable before show, update, and destroy actions
      before_action :set_car, only: [:show, :update, :destroy]

      # GET /api/v1/cars
      def index
        # Find cars associated with the current operator
        @cars = current_operator.cars
        # Render a JSON response with the list of cars
        render json: @cars
      end

      # GET /api/v1/cars/:id
      def show
        # Render a JSON response with the car details
        render json: @car
      end

      # POST /api/v1/cars
      def create
        # Build a new car associated with the current operator
        @car = current_operator.cars.build(car_params)
        
        if @car.save
          render json: @car.reload, status: :created
        else
          # If car creation fails, return error messages
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/cars/:id
      def update
        if @car.reserved && car_params[:reserved].to_s == "false"
          # If the car is currently reserved and the update sets it to not reserved
          if @car.update(car_params)
            # Find the booking associated with the car and update its status to canceled
            booking = Booking.find_by(car_id: @car.id)
            if booking
              booking.update(status: 0)
              # Refund the user's money
              user = booking.user
              user.money += booking.total_price
              user.save
            end
            render json: @car.reload
          else
            # If the update fails, return error messages
            render json: @car.errors, status: :unprocessable_entity
          end
        else
          # For other updates (not related to reservation status)
          if @car.update(car_params)
            render json: @car.reload
          else
            render json: @car.errors, status: :unprocessable_entity
          end
        end
      end

      # DELETE /api/v1/cars/:id
      def destroy
        # Delete the car
        @car.destroy
        # Respond with no content (204) after successful deletion
        head :no_content
      end

      private

      # Set the @car instance variable based on the provided car ID
      def set_car
        @car = Car.find(params[:id])
      end

      # Define permitted parameters for car creation and updates
      def car_params
        params.require(:car).permit(
          :car_brand, :car_name, :fuel_type, :transmission, :car_seats, :car_type,
          :coding_day, :plate_number, :price, :year, :reserved,
          location: [:address, position: [:lat, :lng]],
          images: [],
          blocked_address: []
        )
      end
    end
  end
end
