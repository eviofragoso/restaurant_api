class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[ show update destroy ]

  # GET /menu_items
  def index
    @menu_items = MenuItem.all
    @menu_items = @menu_items.where(restaurant_id: params[:restaurant_id]) if params.key?(:restaurant_id)
    @menu_items = @menu_items.joins(:menus).where(menus: { id: params[:menu_id] }) if params.key?(:menu_id)

    render json: @menu_items
  end

  # GET /menu_items/1
  def show
    render json: @menu_item
  end

  # POST /menu_items
  def create
    @menu_item = MenuItem.new(menu_item_params)

    if @menu_item.save
      render json: @menu_item, status: :created, location: @menu_item
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /menu_items/1
  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /menu_items/1
  def destroy
    @menu_item.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu_item
      @menu_item = MenuItem.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def menu_item_params
      params.expect(menu_item: [ :restaurant_id, :description, :lact_free, :gluten_free, :name ])
    end
end
