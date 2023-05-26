require "faker"

def generate_product_code
  characters = [("A".."Z")].map(&:to_a).flatten
  prefix = characters.sample(4).join
  suffix = rand(1000..9999).to_s

  "#{prefix}#{suffix}"
end

if Rails.env.development?
  # Clear existing data
  Product.destroy_all

  # Generate 20 products
  20.times do
    name = Faker::Commerce.product_name
    # code = Faker::Alphanumeric.unique.alphanumeric(number: 8, min_alpha: 4, min_numeric: 4)
    code = generate_product_code
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
