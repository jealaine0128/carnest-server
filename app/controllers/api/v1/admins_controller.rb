# app/controllers/api/v1/admins_controller.rb

module Api
  module V1
    class AdminsController < ApplicationController
      # Ensure that only authenticated admins can access these actions
      before_action :authenticate_admin!
      # Set the admin instance variable before update and destroy actions
      before_action :set_admin, only: [:update, :destroy]

      # List all admins
      def index
        @admins = Admin.all
        render json: @admins
      end

      # Show details of the currently authenticated admin
      def show
        render json: current_admin
      end

      # Update an admin's information
      def update
        if @admin.update(admin_params)
          render json: @admin
        else
          # If update fails, return error messages
          render json: @admin.errors, status: :unprocessable_entity
        end
      end

      # Delete an admin
      def destroy
        @admin.destroy
        # Respond with no content (204) after successful deletion
        head :no_content
      end

      private

      # Define permitted parameters for admin updates
      def admin_params
        params.require(:admin).permit(:name, :email)
      end

      # Set the @admin instance variable based on the provided admin ID
      def set_admin
        @admin = Admin.find(params[:id])
      end
    end
  end
end
