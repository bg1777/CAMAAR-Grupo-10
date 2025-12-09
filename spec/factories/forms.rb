# spec/factories/forms.rb

FactoryBot.define do
  factory :form do
    association :form_template
    association :klass
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    due_date { 7.days.from_now }
    status { 0 }
  end
end