FactoryBot.define do
  factory :booking do
    operator
    user
    pickup_date { Faker::Date.forward(days: 7).strftime("%Y-%m-%d") }
    pickup_time { Faker::Time.forward(days: 7).strftime("%H:%M:%S") }
    duration { Faker::Number.between(from: 1, to: 7) }
    return_date { Faker::Date.forward(days: 14).strftime("%Y-%m-%d") }
    total_price { Faker::Number.between(from: 100, to: 500) }
    status { Faker::Number.between(from: 1, to: 2) }
    car_info { FactoryBot.create(:car).attributes }
    car_id { 100 }
  end
end
