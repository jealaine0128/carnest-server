class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :operator, foreign_key: true
      t.references :user, foreign_key: true
      t.string :pickup_date
      t.string :pickup_time
      t.integer :duration
      t.string :return_date
      t.integer :total_price
      t.integer :status
      t.timestamps
    end
  end
end