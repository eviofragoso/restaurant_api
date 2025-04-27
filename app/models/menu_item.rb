class MenuItem < ApplicationRecord
  belongs_to :menu

  has_many :menu_menu_items
  has_many :menus, through: :menu_menu_items

  validates :name, presence: true, uniqueness: true
  validates_presence_of :description
end
