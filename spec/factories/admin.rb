# spec/factories/admin.rb
FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { 'password' } # Replace 'password' with your desired password
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { Time.current }
    name { Faker::Name.name }
    jti { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
