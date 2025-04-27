FactoryBot.define do
  factory :menu_item do
    restaurant
    name { Faker::Food.unique.dish }
    description { Faker::Food.description }
    lact_free { false }
    gluten_free { false }
  end
end
