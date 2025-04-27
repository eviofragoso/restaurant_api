class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true, uniqueness: true
  validates_presence_of :description
end
