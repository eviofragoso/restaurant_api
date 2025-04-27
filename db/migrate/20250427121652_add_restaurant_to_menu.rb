class AddRestaurantToMenu < ActiveRecord::Migration[8.0]
  def change
    change_table :menus do |t|
      t.belongs_to :restaurant
    end
  end
end
