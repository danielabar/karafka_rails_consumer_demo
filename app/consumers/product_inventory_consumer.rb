class ProductInventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info(
        "ProductInventoryConsumer consuming Topic: #{topic.name}, \
        Message: #{message.payload},\
        Offset: #{message.offset}"
      )
      service = UpdateProductInventoryService.new(message.payload)
      handle_service_errors(message, service.errors) unless service.process
    end
  end

  private

  def handle_service_errors(message, errors)
    Rails.logger.error("ProductInventoryConsumer message invalid: #{message.payload}, #{errors.join(', ')}")
    dispatch_to_dlq(message)
  end
end
