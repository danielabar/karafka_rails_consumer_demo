class ProductInventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info("ProductInventoryConsumer consuming: Topic: #{topic.name}, Message: #{message.payload}, Offset: #{message.offset}")
      service = UpdateProductInventoryService.new(message.payload)
      Rails.logger.error("ProductInventoryConsumer message invalid: #{service.errors.join(', ')}") unless service.process
      # Optionally could call mark_as_consumed here for manual offset management.
      # In this case, we leave it to Karafka to auto-commit offsets for simplicity.
    end
  end
end
