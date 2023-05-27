class ProductInventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      Rails.logger.info("ProductInventoryConsumer consuming: Topic: #{topic.name}, Message: #{message.payload}, Offset: #{message.offset}")
    rescue StandardError => e
      Rails.logger.error("ProductInventoryConsumer failed: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
