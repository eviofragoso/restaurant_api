require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "Validation" do
    context "presence validation" do
      it "requires the presence of name" do
        expect(build(:restaurant, name: nil)).not_to be_valid
      end

      it "requires the presence of address" do
        expect(build(:restaurant, address: nil)).not_to be_valid
      end
    end
  end
end
