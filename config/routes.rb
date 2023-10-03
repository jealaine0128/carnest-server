Rails.application.routes.draw do
  # Define routes for admins
  devise_for :admins, path: 'admin', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }

  # Define routes for operators
  devise_for :operators, path: 'operator', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'operators/sessions',
    registrations: 'operators/registrations'
  }

  # Define routes for users
  devise_for :users, path: 'user', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  }, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      # Define resources for admins, operators, and users
      resources :admins
      resources :operators, only: [:index, :update]
      resources :users, only: [:index, :create, :update]
      resources :bookings
      resources :cars
      resources :user_admin
      resources :operator_admin
      resources :user_booking, only: [:index, :create, :update, :destroy]
      resources :operator_booking, only: [:index, :update, :destroy]
      resources :all_cars, only: [:index, :show]
    end
  end

end
