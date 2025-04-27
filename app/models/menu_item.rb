class MenuItem < ApplicationRecord
  belongs_to :restaurant

  has_many :menu_menu_items
  has_many :menus, through: :menu_menu_items

  validates :name, presence: true, uniqueness: { scope: :restaurant_id }
end
