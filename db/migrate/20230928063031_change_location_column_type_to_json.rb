class ChangeLocationColumnTypeToJson < ActiveRecord::Migration[7.0]
  def change
    change_column :cars, :location, :json
  end
end
