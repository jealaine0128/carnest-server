# app/controllers/api/v1/operators_controller.rb

module Api
  module V1
    class OperatorsController < ApplicationController
      # Ensure that only authenticated operators can access these actions
      before_action :authenticate_operator!

      # GET /api/v1/operators
      def index
        # Render a JSON response with the details of the current operator
        render json: current_operator
      end

      # PATCH/PUT /api/v1/operators
      def update
        if current_operator.update(operator_params)
          render json: current_operator
        else
          # If the update fails, return error messages
          render json: current_operator.errors, status: :unprocessable_entity
        end
      end

      private

      # Define permitted parameters for operator updates
      def operator_params
        params.require(:operator).permit(:name, :email, :status, :profile, :money, :mobile, :address, :image_id)
      end
    end
  end
end
