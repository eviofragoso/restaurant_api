class Restaurant < ApplicationRecord
  has_many :menus

  validates_presence_of :name, :address
end
