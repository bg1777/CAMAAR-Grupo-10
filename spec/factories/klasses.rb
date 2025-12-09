# spec/factories/klasses.rb

FactoryBot.define do
  factory :klass do
    sequence(:code) { |n| "CIC#{1000 + n}" }
    name { Faker::Lorem.sentence }
    semester { "2021.2" }
    description { Faker::Lorem.paragraph }
  end
end