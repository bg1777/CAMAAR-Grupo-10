# spec/factories/form_template_fields.rb

FactoryBot.define do
  factory :form_template_field do
    association :form_template
    field_type { 'text' }
    label { Faker::Lorem.word }
    required { false }
    options { [] }
    position { 1 }
  end
end