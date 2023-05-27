require "rails_helper"

RSpec.describe ProductInventory, type: :model do
  subject(:product_inventory_form) { described_class.new }

  describe "validations" do
    it { should validate_presence_of(:product_code) }
    it { should validate_presence_of(:inventory_count) }
    it { should validate_numericality_of(:inventory_count).only_integer.is_greater_than_or_equal_to(0) }

    context "custom validation" do
      let(:product) { create(:product) }
      let(:product_inventory_form) { ProductInventory.new(product_code: product.code, inventory_count: 10) }

      it "is valid when product exists" do
        expect(product_inventory_form).to be_valid
      end

      it "is not valid when product does not exist" do
        product_inventory_form.product_code = "INVALID"
        expect(product_inventory_form).not_to be_valid
        expect(product_inventory_form.errors[:product_code]).to include("#{product_inventory_form.product_code} does not exist")
      end
    end
  end
end
