FactoryBot.define do
  factory :menu do
    restaurant
    availability { 1 }
    name { Faker::Food.ethnic_category }
    description { Faker::Restaurant.type  }
    signed_chef { Faker::Name.name }
    day_period { 1 }
  end
end
