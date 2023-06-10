class ProductInventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info(
        "ProductInventoryConsumer consuming Topic: #{topic.name}, \
        Message: #{message.payload},\
        Offset: #{message.offset}"
      )
      service = UpdateProductInventoryService.new(message.payload)
      unless service.process
        Rails.logger.error("ProductInventoryConsumer message invalid: #{service.errors.join(', ')}")
        dispatch_to_dlq(message)
      end
    end
  end
end
