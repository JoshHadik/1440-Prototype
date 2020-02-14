FactoryBot.define do
  factory :user do
    email do
      Faker::Internet.email
    end

    sequence(:password) do |n|
      "password#{n}"
    end

    password_confirmation do
      password
    end
  end
end
