class AddCarIdToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :car_id, :integer
  end
end
