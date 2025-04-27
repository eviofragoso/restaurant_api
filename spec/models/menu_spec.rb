require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "Validation" do
    context "presence validation" do
      it "requires the presence of name" do
        expect(FactoryBot.build(:menu, name: nil)).not_to be_valid
      end

      it "requires the presence of day_period" do
        expect(FactoryBot.build(:menu, day_period: nil)).not_to be_valid
      end

      it "requires the presence of availability" do
        expect(FactoryBot.build(:menu, availability: nil)).not_to be_valid
      end
    end
  end
end
