class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :car_brand
      t.string :car_name
      t.string :fuel_type
      t.string :transmission
      t.integer :car_seats
      t.string :car_type
      t.string :coding_day
      t.string :plate_number
      t.json :location
      t.json :images
      t.integer :price
      t.string :year
      t.references :operator, foreign_key: true
      t.boolean :reserved, default: false
      t.timestamps
    end
  end
end
