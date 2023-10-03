class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false
    add_index :users, :jti, unique: true
    add_column :admins, :jti, :string, null: false
    add_index :admins, :jti, unique: true
    add_column :operators, :jti, :string, null: false
    add_index :operators, :jti, unique: true
  end
end
