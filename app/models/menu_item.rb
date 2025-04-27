class MenuItem < ApplicationRecord
  belongs_to :menu

  validates_presence_of :name, :description
end
