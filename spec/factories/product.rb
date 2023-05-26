# spec/factories/product.rb

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    code do
      "#{Faker::Alphanumeric.unique.upcase_letter}#{Faker::Alphanumeric.unique.upcase_letter}#{Faker::Alphanumeric.unique.upcase_letter}#{Faker::Alphanumeric.unique.upcase_letter}#{Faker::Number.unique.number(digits: 4)}"
    end
    price { Faker::Commerce.price(range: 1..100) }
    inventory { Faker::Number.between(from: 0, to: 100) }
  end
end
