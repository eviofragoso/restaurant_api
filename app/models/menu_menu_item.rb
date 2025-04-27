class MenuMenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item

  validates :menu, uniqueness: { scope: :menu_item }
end
