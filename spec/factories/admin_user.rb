require 'factory_girl'

FactoryGirl.define do
  factory :admin_user do
    sequence(:email) {|n| "#{Faker::Internet.email}#{n}"}
    password Faker::Lorem.characters(10)
  end
end
