require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe "Validation" do
    context "presence validation" do
      it "requires the presence of name" do
        expect(build(:menu_item, name: nil)).not_to be_valid
      end

      it "requires the presence of description" do
        expect(build(:menu_item, description: nil)).not_to be_valid
      end

      it "requires the presence of menu" do
        expect(build(:menu_item, menu_id: nil)).not_to be_valid
      end
    end

    context "uniqueness" do
      it "validates uniqueness of name" do
        expect(build(:menu_item, name: nil)).not_to be_valid
      end
    end
  end
end
