# app/controllers/api/v1/operator_booking_controller.rb

module Api
  module V1
    class OperatorBookingController < ApplicationController
      # Ensure that only authenticated operators can access these actions
      before_action :authenticate_operator!
      # Set the booking instance variable before update and destroy actions
      before_action :set_booking, only: [:update, :destroy]

      # GET /api/v1/operator_booking
      def index
        # Retrieve bookings associated with the current operator, including user and operator details
        @bookings = current_operator.bookings.includes(:user, :operator)
        # Render a JSON response with the list of bookings, including user and operator details
        render json: @bookings, include: [:user, :operator]
      end

      # PUT /api/v1/operator_booking/:id
      def update
        if @booking.update(status: 3)
          total_price = @booking.total_price

          # Calculate the 10% fee for the operator
          fee = total_price * 0.10

          # Update the operator's money, deducting the fee
          @booking.operator.money += (total_price - fee).to_i
          @booking.operator.save

          # Render a JSON response with the updated booking
          render json: @booking
        else
          # If the update fails, return error messages
          render json: @booking.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/operator_booking/:id
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
    end
  end
end
