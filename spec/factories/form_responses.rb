# spec/factories/form_responses.rb

FactoryBot.define do
  factory :form_response do
    association :form
    association :user
    submitted_at { nil }
  end
end