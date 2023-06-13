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

  it "logs error and produces to DLQ when given invalid payload" do
    expect(Karafka.logger).to receive(:info).with(/Sync producing of a message/)
    expect(Rails.logger).to receive(:info).with(/ProductInventoryConsumer consuming Topic: inventory_management_product_updates/)
    expect(Rails.logger).to receive(:error).with(/ProductInventoryConsumer message invalid/)
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
end
