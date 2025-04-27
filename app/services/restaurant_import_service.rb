class RestaurantImportService
  PERMITTED_MENU_ITEMS_KEYS = %i[menu_items dishes]

  def initialize(file)
    @file = file
    @service_logging = []
  end

  def call
    data = file_content

    raise "Missing restaurants info" unless data.key?(:restaurants)

    data[:restaurants].each do |restaurant_attributes|
      persist_restaurant(restaurant_attributes)
    end
  end

  private

  def file_content
    JSON.parse(@file.read, symbolize_names: true)
  rescue JSON::ParserError => e
    Rails.logger.error("[RestaurantImportService] Invalid JSON file: #{e.message}")
  end

  def persist_restaurant(restaurant_attributes)
    restaurant = Restaurant.create!(name: restaurant_attributes[:name])

    restaurant_attributes[:menus].each do |menu_attributes|
      persist_menu(restaurant, menu_attributes)
    end
  end

  def persist_menu(restaurant, menu_attributes)
    menu           = restaurant.menus.create!(name: menu_attributes[:name])
    menu_items_key = PERMITTED_MENU_ITEMS_KEYS.find { |key| menu_attributes.key?(key) }

    raise "Permitted menu item key not found" unless menu_items_key

    menu_attributes[menu_items_key].each do |menu_item_attributes|
      persist_menu_item(restaurant, menu, menu_item_attributes)
    end
  end

  def persist_menu_item(restaurant, menu, menu_item_attributes)
    menu_item = restaurant.menu_items.where(menu_item_attributes[:name]).first_or_create

    menu.menu_menu_items.create!(
      menu_item: menu_item,
      price: menu_item_attributes[:price]
    )
  end


  def log_menu_item_persistence_success(attributes)
    log_text = "[RestaurantImportService] Success persisting menu item with attributes: #{attributes}"

    Rails.logger.info(log_text)

    log_text
  end

  def log_menu_item_persistence_error(attributes, exception)
    log_text = <<~TEXT
      [RestaurantImportService] Error persisting menu item with attributes: #{attributes}.
      -- The following error was raised: #{e.message}
    TEXT

    Rails.logger.error(log_text)

    log_text
  end
end
