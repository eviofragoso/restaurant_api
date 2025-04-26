class Menu < ApplicationRecord
  enum :availability, { all_time: 0, seasonal: 1 }, default: :all_time
  enum :day_period, { all_day: 0, dinner: 1, lunch: 2, breakfast: 3 }, default: :all_day

  has_many :menu_items

  validates_presence_of :availability, :day_period, :name
end
