class AddInfoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
    add_column :users, :profile, :string
    add_column :users, :money, :integer
    add_column :users, :status, :string
    add_column :users, :address, :string
    add_column :users, :mobile, :string
    add_column :users, :image_id, :string
  end
end
