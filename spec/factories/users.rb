FactoryBot.define do
  factory :user do
    id { (1..100).to_a.sample }
    email { Faker::Internet.email }
    password { 'fake password' }
    password_confirmation { 'fake password' }
    admin { false }

    trait(:admin) do
      admin { true }
    end

    factory :admin_user, traits: [:admin]
  end
end
