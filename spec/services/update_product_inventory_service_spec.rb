require "rails_helper"

RSpec.describe UpdateProductInventoryService do
  describe "#process" do
    let(:product) { FactoryBot.create(:product, inventory: 5) }

    context "when the product inventory form is valid" do
      it "updates the product inventory and returns true" do
        payload = { product_code: product.code, inventory_count: 10 }
        service = described_class.new(payload)

        result = service.process
        expect(result).to eq(true)
        expect(service.errors).to be_empty

        product.reload
        expect(product.inventory).to eq(10)
      end
    end

    context "when the product inventory form is invalid" do
      it "does not update the product inventory" do
        payload = { product_code: product.code, inventory_count: -1 }
        service = described_class.new(payload)

        result = service.process
        expect(result).to eq(false)
        expect(service.errors).to include("Inventory count must be greater than or equal to 0")

        product.reload
        expect(product.inventory).to eq(5)
      end
    end
  end
end
