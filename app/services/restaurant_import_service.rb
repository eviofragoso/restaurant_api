class RestaurantImportService
  PERMITTED_MENU_ITEMS_KEYS = %i[menu_items dishes]

  def initialize(json_data)
    @json_data = json_data
    @service_logging = []
    @error = nil
  end

  def call
    ActiveRecord::Base.transaction do
      raise "Missing restaurants info" unless @json_data.key?(:restaurants)

      @json_data[:restaurants].each do |restaurant_attributes|
        persist_restaurant(restaurant_attributes)
      end
    rescue StandardError => e
      @error = e
    end

    [ @service_logging, @error ]
  end

  private

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
    menu_item = restaurant.menu_items.where(name: menu_item_attributes[:name]).first
    menu_item ||= restaurant.menu_items.create!(name: menu_item_attributes[:name])

    menu.menu_menu_items.create!(
      menu_item: menu_item,
      price: menu_item_attributes[:price]
    )

    log_menu_item(menu_item_attributes, menu, restaurant)
  rescue ActiveRecord::RecordInvalid => e
    log_menu_item(menu_item_attributes, menu, restaurant, e)
  end

  def log_menu_item(attributes, menu, restaurant, exception = nil)
    log = {
      status: :ok,
      restaurant: restaurant.name,
      menu: menu.name,
      attributes: attributes
    }

    if exception
      log[:error]  = exception.message
      log[:status] = :fail
    end

    Rails.logger.error("RestaurantImportService] #{log}")

    @service_logging << log
  end
end
