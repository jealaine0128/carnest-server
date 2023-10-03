# app/controllers/api/v1/user_booking_controller.rb

module Api
  module V1
    class UserBookingController < ApplicationController
      # Ensure that only authenticated users can access these actions
      before_action :authenticate_user!
      # Set the booking instance variable before destroy action
      before_action :set_booking, only: [:destroy]

      # GET /api/v1/user_booking
      def index
        # Retrieve bookings associated with the current user, including user and operator details
        @bookings = current_user.bookings.includes(:user, :operator)
        # Render a JSON response with the list of bookings, including user and operator details
        render json: @bookings, include: [:user, :operator]
      end

      # POST /api/v1/user_booking
      def create
        # Find the car associated with the booking by its ID
        car = Car.find(booking_params[:car_id])

        # Prepare the booking parameters, including car information
        updated_booking_params = booking_params.to_h.except(:car_id).merge(car_info: car, car_id: car.id)

        # Build a new booking associated with the current user
        @booking = current_user.bookings.build(updated_booking_params)

        # Check if the user has sufficient balance to make the booking
        if current_user.money >= @booking.total_price
          if @booking.save
            # Mark the associated car as reserved
            car.update(reserved: true)

            # Calculate the 10% fee for the booking
            fee = @booking.total_price * 0.10

            # Deduct the total booking cost and fee from the user's balance
            current_user.money -= (@booking.total_price + fee).to_i
            current_user.save

            # Render a JSON response with the created booking and a status of 201 (Created)
            render json: @booking, status: :created
          else
            # If booking creation fails, return error messages with a status of 422 (Unprocessable Entity)
            render json: @booking.errors, status: :unprocessable_entity
          end
        else
          # If the user has insufficient balance, return an error message with a status of 422 (Unprocessable Entity)
          render json: { error: "Insufficient balance to make the booking" }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/user_booking/:id
      def destroy
        if @booking.update(status: 0)
          # Refund the user's money
          @booking.user.money += @booking.total_price
          if @booking.user.save
            render json: { message: 'Booking successfully canceled and refunded' }, status: :ok
          else
            render json: { error: 'Failed to refund the user' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Unable to cancel booking' }, status: :unprocessable_entity
        end
      end

      private

      # Set the @booking instance variable based on the provided booking ID
      def set_booking
        @booking = Booking.find(params[:id])
      end

      # Define permitted parameters for booking creation
      def booking_params
        params.require(:booking).permit(
          :operator_id, :user_id, :pickup_date, :pickup_time, :duration, 
          :return_date, :total_price, :status, :car_id
        )
      end
    end
  end
end
