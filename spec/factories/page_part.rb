require 'factory_girl'

FactoryGirl.define do
  factory :page_part, class: Cardboard::PagePart do
    identifier 'slideshow'
    page
  end
end
