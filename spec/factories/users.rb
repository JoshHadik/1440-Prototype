FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:password){|n| "password#{n}" }
    password_confirmation { password }
  end
end
