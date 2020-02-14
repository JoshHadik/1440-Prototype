FactoryBot.define do
  factory :activity_log do
    user do
      FactoryBot.build(:user)
    end

    started_at do
      Time.zone.parse(Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).to_s)
    end

    ended_at do
      Time.zone.parse(Faker::Time.between(from: started_at, to: DateTime.now).to_s)
    end

    label do
      ["Run", "Swim", "Work", "Cook", "Sleep", "Read"].sample
    end

    trait :no_user do
      user { nil }
    end

    trait :invalid do
      started_at { nil }
      ended_at { nil }
      label { nil }
    end
  end
end
