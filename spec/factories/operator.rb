FactoryBot.define do
    factory :operator do
      email { Faker::Internet.email }
      password {'password'}
      reset_password_token { nil }
      reset_password_sent_at { nil }
      remember_created_at { nil }
      created_at { Faker::Time.backward(days: 30) }
      updated_at { Time.current }
      name { Faker::Company.name }
      status { 'active' }
      profile { Faker::Lorem.paragraph }
      money { Faker::Number.between(from: 1000, to: 10000) }
      mobile { Faker::PhoneNumber.phone_number }
      address { Faker::Address.full_address }
      image_id { nil }
      jti { Faker::Alphanumeric.alphanumeric(number: 10) }
    end
  end