# spec/factories/form_templates.rb

FactoryBot.define do
  factory :form_template do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :user, factory: :user
  end
end