require "rails_helper"

RSpec.describe ProductInventoryConsumer do
  subject(:consumer) { karafka.consumer_for("inventory_management_product_updates") }
  let(:product) { create(:product, inventory: 10) }

  it "updates product inventory when given a valid payload" do
    expect(Karafka.logger).to receive(:info).with(/Sync producing of a message/)
    expect(Rails.logger).to receive(:info).with(/ProductInventoryConsumer consuming Topic: inventory_management_product_updates/)

    message = {
      product_code: product.code,
      inventory_count: 15
    }

    karafka.produce(message.to_json)
    consumer.consume

    expect(product.reload.inventory).to eq(15)
  end

  it "logs error and produces to DLQ when given message with invalid product code" do
    expect(Karafka.logger).to receive(:info).with(/Sync producing of a message/)
    expect(Rails.logger).to receive(:info).with(/ProductInventoryConsumer consuming Topic: inventory_management_product_updates/)
    expect(Rails.logger).to receive(:error).with(/ProductInventoryConsumer message invalid.+Product code NOSUCHCODE does not exist/)
    expect(Karafka.logger).to receive(:info).with(/Async producing of a message to 'dlq_inventory_management_product_updates'/)
    expect(Karafka.logger).to receive(:info).with(/Dispatched message/)

    message = {
      product_code: "NOSUCHCODE",
      inventory_count: 15
    }

    karafka.produce(message.to_json)
    consumer.consume

    expect(product.reload.inventory).to eq(10)
    expect(karafka.produced_messages.last[:topic]).to eq("dlq_inventory_management_product_updates")
  end

  it "raises exception on invalid message format" do
    message = "not a json message"

    karafka.produce(message)
    expect { consumer.consume }.to raise_error(JSON::ParserError, "unexpected token at 'not a json message'")
  end

  it "raises exception on unexpected message attributes" do
    message = {
      greeting: "hello"
    }

    karafka.produce(message.to_json)
    expect { consumer.consume }.to raise_error(ActiveModel::UnknownAttributeError, /unknown attribute 'greeting' for ProductInventoryForm/)
  end

  it "raises exception when service raises" do
    message = {
      product_code: product.code,
      inventory_count: 15
    }

    service = instance_double("UpdateProductInventoryService")
    expect(UpdateProductInventoryService).to receive(:new)
      .with(message.with_indifferent_access)
      .and_return(service)
    expect(service).to receive(:process)
      .and_raise(ActiveRecord::ConnectionTimeoutError)

    karafka.produce(message.to_json)
    expect { consumer.consume }.to raise_error(ActiveRecord::ConnectionTimeoutError)
  end
end
