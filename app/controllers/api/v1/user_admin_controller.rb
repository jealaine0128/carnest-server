# app/controllers/api/v1/user_admin_controller.rb

module Api
  module V1
    class UserAdminController < ApplicationController
      # Ensure that only authenticated admins can access these actions
      before_action :authenticate_admin!
      # Set the user instance variable before show, update, and destroy actions
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /api/v1/user_admin
      def index
        # Retrieve all users from the database
        @users = User.all
        # Render a JSON response with the list of users
        render json: @users
      end

      # GET /api/v1/user_admin/:id
      def show
        # Render a JSON response with the user details, including associated bookings
        render json: @user, include: :bookings
      end

      # PATCH/PUT /api/v1/user_admin/:id
      def update
        if @user.update(user_params)
          render json: @user
        else
          # If the update fails, return error messages
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/user_admin/:id
      def destroy
        # Delete the user
        @user.destroy
        # Respond with no content (204) after successful deletion
        head :no_content
      end

      private

      # Set the @user instance variable based on the provided user ID
      def set_user
        @user = User.find(params[:id])
      end

      # Define permitted parameters for user updates
      def user_params
        params.permit(:name, :email, :status, :profile, :money, :mobile, :address, :image_id)
      end
    end
  end
end
