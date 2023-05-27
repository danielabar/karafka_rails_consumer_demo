class ProductInventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      process_message(message)
      # Optionally could call mark_as_consumed here for manual offset management.
      # In this case, we leave it to Karafka to auto-commit offsets for simplicity.
    rescue StandardError => e
      Rails.logger.error("ProductInventoryConsumer failed: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end

  def process_message(message)
    Rails.logger.info("ProductInventoryConsumer consuming: Topic: #{topic.name}, Message: #{message.payload}, Offset: #{message.offset}")
    service = UpdateProductInventoryService.new(message.payload)
    Rails.logger.error("ProductInventoryConsumer failed: #{service.errors.join(', ')}") unless service.process
  end
end
