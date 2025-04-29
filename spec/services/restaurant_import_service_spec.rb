require 'rails_helper'

RSpec.describe RestaurantImportService do
  describe "#call" do
    let(:valid_attributes) {
      {
        restaurants: [
          {
            name: Faker::Restaurant.name,
            menus: [
              {
                name: Faker::Food.ethnic_category,
                menu_items: [
                  { name: Faker::Food.unique.dish, price: 120.0 },
                  { name: Faker::Food.unique.dish, price: 35.0 }
                ]
              }
            ]
          }
        ]
      }
    }

    let(:service_return_data) { described_class.new(valid_attributes).call }

    context "valid_attributes" do
      it "saves the data successfully" do
        expect { described_class.new(valid_attributes).call }.to change { Restaurant.count }.by(1)
                               .and change { Menu.count }.by(1)
                               .and change { MenuItem.count }.by(2)
                               .and change { MenuMenuItem.count }.by(2)
      end

      it "return the menu items logs and nil (represents no error)" do
        logs, error = service_return_data

        expect(error).to be_nil
        expect(logs.size).to eq(2)
      end
    end

    context "wrong restaurant key" do
      it "Don't save partial data" do
        expect { described_class.new({}).call }.to change { Restaurant.count }.by(0)
                                .and change { Menu.count }.by(0)
                                .and change { MenuItem.count }.by(0)
                                .and change { MenuMenuItem.count }.by(0)
      end

      it "raises missing restaurant info" do
        _, error = described_class.new({}).call

        expect(error).to be_a(StandardError)
        expect(error.message).to eq("Missing restaurants info")
      end
    end

    context "wrong menu_items key" do
      let(:invalid_menu_item_key_attributes) {
        {
          restaurants: [
            {
              name: Faker::Restaurant.name,
              menus: [
                {
                  name: Faker::Food.ethnic_category,
                  items: [
                    { name: Faker::Food.unique.dish, price: 120.0 },
                    { name: Faker::Food.unique.dish, price: 35.0 }
                  ]
                }
              ]
            }
          ]
        }
      }

      it "raises permitted menu item key not found" do
        _, error = described_class.new(invalid_menu_item_key_attributes).call

        expect(error).to be_a(StandardError)
        expect(error.message).to eq("Permitted menu item key not found")
      end
    end

    context "Duplicated menu item name in the same restaurant but different menus" do
      let(:duplicate_in_restaurant_params) {
        {
          restaurants: [
            {
              name: Faker::Restaurant.name,
              menus: [
                {
                  name: Faker::Food.ethnic_category,
                  menu_items: [
                    { name: "fries", price: 120.0 }
                  ]
                },
                {
                  name: Faker::Food.ethnic_category,
                  menu_items: [
                    { name: "fries", price: 120.0 }
                  ]
                }
              ]
            }
          ]
        }
      }

      it "persists successfuly in different menus" do
        logs, error = described_class.new(duplicate_in_restaurant_params).call

        expect(error).to be_nil
        expect(logs.map { |log| log[:status] }).to eq([ :ok, :ok ])
      end
    end

    context "Duplicated menu item name in the same menu" do
      let(:duplicate_in_menu_params) {
        {
          restaurants: [
            {
              name: Faker::Restaurant.name,
              menus: [
                {
                  name: Faker::Food.ethnic_category,
                  menu_items: [
                    { name: "fries", price: 120.0 },
                    { name: "fries", price: 35.0 }
                  ]
                }
              ]
            }
          ]
        }
      }

      it "fails to persist in same menu" do
        logs, error = described_class.new(duplicate_in_menu_params).call

        expect(error).to be_nil
        expect(logs.map { |log| log[:status] }).to eq([ :ok, :fail ])
      end
    end
  end
end
