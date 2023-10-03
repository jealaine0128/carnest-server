class AddCarInfoToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :car_info, :json
  end
end
