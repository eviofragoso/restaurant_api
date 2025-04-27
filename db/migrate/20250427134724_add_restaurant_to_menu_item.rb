class AddRestaurantToMenuItem < ActiveRecord::Migration[8.0]
  def up
    add_column :menu_items, :restaurant_id, :bigint
    add_index :menu_items, :restaurant_id

    MenuItem.find_each do |menu_item|
      menu_item.update(restaurant_id: menu_item.menu.restaurant_id)
    end

    change_column_null(:menu_items, :restaurant_id, true)

    remove_column :menu_items, :menu_id
  end

  def down
    add_column :menu_items, :menu_id, :bigint
    add_index :menu_items, :menu_id

    MenuItem.find_each do |menu_item|
      existing_menus = menu_item.restaurant.menus
      menu_item.destroy unless existing_menus.any?

      menu_item.update(menu_id: existing_menus.first.id)
    end

    change_column_null(:menu_items, :menu_id, true)

    remove_column :menu_items, :restaurant_id
  end
end
