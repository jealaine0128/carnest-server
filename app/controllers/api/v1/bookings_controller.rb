# app/controllers/api/v1/bookings_controller.rb

module Api
  module V1
    class BookingsController < ApplicationController
      # Ensure that only authenticated admins can access these actions
      before_action :authenticate_admin!
      # Set the booking instance variable before show, update, and destroy actions
      before_action :set_booking, only: [:show, :update, :destroy]

      # GET /api/v1/bookings
      def index
        # Retrieve all bookings from the database, including associated user and operator
        @bookings = Booking.all.includes(:user, :operator)
        # Render a JSON response with the list of bookings, including user and operator details
        render json: @bookings, include: [:user, :operator]
      end

      # GET /api/v1/bookings/:id
      def show
        # Find and retrieve a specific booking by its ID
        @booking = Booking.find(params[:id])
        # Render a JSON response with the booking details
        render json: @booking
      end

      # PATCH/PUT /api/v1/bookings/:id
      def update
        # Update the status of the booking to 2 (presumably completed)
        if @booking.update(status: 2)
          render json: @booking
        else
          # If the update fails, return error messages
          render json: @booking.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bookings/:id
      def destroy
        # Update the status of the booking to 0 (presumably canceled)
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

      # Define permitted parameters for booking updates
      def booking_params
        params.require(:booking).permit(:operator_id, :user_id, :pickup_date, :pickup_time, :duration, :return_date, :total_price, :status)
      end
    end
  end
end
