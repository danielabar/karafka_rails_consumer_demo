class UpdateProductInventoryService
  attr_reader :errors, :payload

  def initialize(payload)
    @payload = payload
    @errors = []
  end

  def process
    product_inventory_form = ProductInventoryForm.new(payload)
    if product_inventory_form.valid?
      update_product(product_inventory_form)
      true
    else
      errors.push(*product_inventory_form.errors.full_messages)
      false
    end
  rescue StandardError => e
    errors.push("Record could not be saved: #{e.message}\n#{e.backtrace.join("\n")}")
  end

  private

  def update_product(product_inventory_form)
    product = Product.find_by(code: product_inventory_form.product_code)
    product.update!(inventory: product_inventory_form.inventory_count)
  end
end
