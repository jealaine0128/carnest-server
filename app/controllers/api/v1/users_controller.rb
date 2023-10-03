# app/controllers/api/v1/users_controller.rb

module Api
  module V1
    class UsersController < ApplicationController
      # Ensure that only authenticated users can access these actions
      before_action :authenticate_user!

      # GET /api/v1/users
      def index
        # Render a JSON response with the details of the current user
        render json: current_user
      end

      # POST /api/v1/users
      def create
        # Extract the money amount from user_params and convert it to an integer
        money = user_params[:money].to_i
        # Add the money amount to the user's balance
        current_user.money += money

        if current_user.save
          # If the user's balance is successfully updated, render a JSON response with the updated user and a status of 200 (OK)
          render json: current_user, status: :ok
        else
          # If the update fails, return error messages with a status of 422 (Unprocessable Entity)
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/users/:id
      def update
        if current_user.update(user_params)
          # If the user's information is successfully updated, render a JSON response with the updated user
          render json: current_user
        else
          # If the update fails, return error messages with a status of 422 (Unprocessable Entity)
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      private

      # Define permitted parameters for user updates and balance addition
      def user_params
        params.require(:user).permit(:name, :email, :profile, :money, :status, :address, :mobile, :image_id)
      end
    end
  end
end
