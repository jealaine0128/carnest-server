class AddBlockedAddressToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :blocked_address, :json
  end
end
