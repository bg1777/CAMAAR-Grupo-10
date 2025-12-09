# spec/factories/class_members.rb

FactoryBot.define do
  factory :class_member do
    user
    klass
    role { 'dicente' }
  end
end