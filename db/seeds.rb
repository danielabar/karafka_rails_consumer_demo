require "faker"

if Rails.env.development?
  Product.destroy_all

  20.times do
    name = Faker::Commerce.product_name
    code = "#{Faker::Alphanumeric.alpha(number: 4).upcase}#{Faker::Number.number(digits: 4)}"
    price = Faker::Commerce.price(range: 0..100.0)
    inventory = rand(0..50)

    Product.create!(
      name:,
      code:,
      price:,
      inventory:
    )
  end

  puts "Seeding completed!"
else
  puts "Seeding skipped. Not in development environment."
end
