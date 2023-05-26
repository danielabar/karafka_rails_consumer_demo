class ProductInventory
  include ActiveModel::Model

  attr_accessor :product_code, :inventory_count

  validates :product_code, presence: true
  validates :inventory_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Only invoke the `product_exists?` validation if there are no validation errors with product_code.
  # For example, if product_code is blank, it doesn't make sense to try and check if it exists.
  # This is accomplished by specifying a "stabby lamda" (i.e. anonymous function) to the "if" hash key,
  # i.e. the `validate` method accepts a hash of options, one of them being `if` to specify the conditions
  # under which the given validation should run.
  validate :product_exists?, if: -> { errors[:product_code].blank? }

  def product_exists?
    errors.add(:product_code, "#{product_code} does not exist") unless Product.exists?(code: product_code)
  end
end
