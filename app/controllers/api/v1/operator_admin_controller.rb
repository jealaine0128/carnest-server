# app/controllers/api/v1/operator_admin_controller.rb

module Api
  module V1
    class OperatorAdminController < ApplicationController
      # Ensure that only authenticated admins can access these actions
      before_action :authenticate_admin!
      # Set the operator instance variable before show, update, and destroy actions
      before_action :set_operator, only: [:show, :update, :destroy]

      # GET /api/v1/operator_admin
      def index
        # Retrieve all operators from the database
        @operators = Operator.all
        # Render a JSON response with the list of operators
        render json: @operators
      end

      # GET /api/v1/operator_admin/:id
      def show
        # Render a JSON response with the operator details, including associated bookings and cars
        render json: @operator, include: [:bookings, :cars]
      end

      # PATCH/PUT /api/v1/operator_admin/:id
      def update
        if @operator.update(operator_params)
          render json: @operator
        else
          # If the update fails, return error messages
          render json: @operator.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/operator_admin/:id
      def destroy
        # Delete the operator
        @operator.destroy
        # Respond with no content (204) after successful deletion
        head :no_content
      end

      private

      # Set the @operator instance variable based on the provided operator ID
      def set_operator
        @operator = Operator.find(params[:id])
      end

      # Define permitted parameters for operator updates
      def operator_params
        params.permit(:name, :email, :password, :password_confirmation, :status, :profile, :money, :mobile, :address, :image_id)
      end
    end
  end
end
