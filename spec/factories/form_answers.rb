# spec/factories/form_answers.rb

FactoryBot.define do
  factory :form_answer do
    association :form_response
    association :form_template_field
    answer { Faker::Lorem.sentence }
  end
end