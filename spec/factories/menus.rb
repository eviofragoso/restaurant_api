FactoryBot.define do
  factory :menu do
    availability { 1 }
    name { "Michellin Rated Menu" }
    description { "Menu for people with refined taste" }
    signed_chef { "Gordon Ramsay" }
    day_period { 1 }
  end
end
