# spec/factories/cars.rb
FactoryBot.define do
  factory :car do
    car_brand { Faker::Vehicle.make }
    car_name { Faker::Vehicle.model }
    fuel_type { Faker::Vehicle.fuel_type }
    transmission { Faker::Vehicle.transmission }
    car_seats { Faker::Number.between(from: 2, to: 7) }
    car_type { Faker::Vehicle.car_type }
    coding_day { Faker::Date.forward(days: 7).strftime("%A") }
    plate_number { Faker::Vehicle.license_plate }
    location do
      {
        "latitude" => Faker::Address.latitude,
        "longitude" => Faker::Address.longitude
      }
    end
    images { [] }
    price { Faker::Number.between(from: 30, to: 200) }
    year { Faker::Vehicle.year }
    reserved { false }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Time.current }
    operator
  end
end
