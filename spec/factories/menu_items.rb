FactoryBot.define do
  factory :menu_item do
    restaurant
    name { "Grilled ribeye" }
    description { "150g ribeye salted then grilled" }
    lact_free { false }
    gluten_free { false }
  end
end
