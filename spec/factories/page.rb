require 'factory_girl'

FactoryGirl.define do
  factory :page, class: Cardboard::Page do
    sequence(:identifier) { |n| "page#{n}" }
    template
  end
end
