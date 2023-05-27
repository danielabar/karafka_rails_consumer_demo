# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  inventory  :integer          default(0), not null
#  name       :string           not null
#  price      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Product, type: :model do
  subject(:product) { FactoryBot.build(:product) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:inventory) }
    it { is_expected.to validate_numericality_of(:inventory).is_greater_than_or_equal_to(0) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(product).to be_valid
    end
  end
end
