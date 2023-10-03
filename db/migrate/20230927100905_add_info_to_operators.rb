class AddInfoToOperators < ActiveRecord::Migration[7.0]
  def change
    add_column :operators, :name, :string
    add_column :operators, :status, :string
    add_column :operators, :profile, :string
    add_column :operators, :money, :integer
    add_column :operators, :mobile, :string
    add_column :operators, :address, :string
    add_column :operators, :image_id, :string
  end
end
