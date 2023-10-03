class RemoveCarInfoFromCars < ActiveRecord::Migration[7.0]
  def change
    remove_column :cars, :car_info, :json
    add_column :bookings, :car_info, :json
  end
end
