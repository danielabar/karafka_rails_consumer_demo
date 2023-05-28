# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  inventory  :integer          default(0), not null
#  name       :string           not null
#  price      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
  validates :price, presence: true
  validates :inventory, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def inspect
    "#<Product id: #{id}, name: #{name}, code: #{code}, price: #{formatted_price}, inventory: #{inventory}>"
  end

  def formatted_price
    format("%.2f", price)
  end
end
