class Menu < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_menu_items, dependent: :destroy
  has_many :menu_items, through: :menu_menu_items

  validates_presence_of :availability, :day_period, :name

  enum :availability, { all_time: 0, seasonal: 1 }, default: :all_time
  enum :day_period, { all_day: 0, dinner: 1, lunch: 2, breakfast: 3 }, default: :all_day
end
