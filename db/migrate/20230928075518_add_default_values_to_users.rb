class AddDefaultValuesToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :status, 'pending'
    change_column_default :users, :money, 0
    change_column_default :operators, :status, 'pending'
    change_column_default :operators, :money, 0
  end
end
