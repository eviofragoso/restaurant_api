require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "Validation" do
    context "presence validation" do
      it "requires the presence of name" do
        expect(build(:menu, name: nil)).not_to be_valid
      end

      it "requires the presence of day_period" do
        expect(build(:menu, day_period: nil)).not_to be_valid
      end

      it "requires the presence of availability" do
        expect(build(:menu, availability: nil)).not_to be_valid
      end
    end
  end

  describe "associations" do
    it "lets menu have multiple menu items" do
      restaurant = create(:restaurant)
      menu_item_1 = create(:menu_item, restaurant_id: restaurant.id)
      menu_item_2 = create(:menu_item, restaurant_id: restaurant.id)

      expect(build(:menu, restaurant_id: restaurant.id, menu_item_ids: [ menu_item_1.id, menu_item_2.id ])).to be_valid
    end
  end
end
