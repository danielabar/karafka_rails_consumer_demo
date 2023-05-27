# spec/factories/product.rb

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    code { "#{Faker::Alphanumeric.alpha(number: 4).upcase}#{Faker::Number.number(digits: 4)}" }
    price { Faker::Commerce.price(range: 1..100) }
    inventory { Faker::Number.between(from: 0, to: 100) }
  end
end
