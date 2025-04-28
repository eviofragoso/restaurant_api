class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[ show update destroy ]
  before_action :check_file, only: %i[ import ]

  # GET /restaurants
  def index
    @restaurants = Restaurant.all

    render json: @restaurants
  end

  # POST /restaurants/import
  def import
    return render json: { error: "No file uploaded" }, status: :bad_request unless @file
    return render json: { error: "Unsupported file type" }, status: :bad_request unless @file.content_type == "application/json"

    begin
      file_data = JSON.parse(@file.read, symbolize_names: true)
    rescue JSON::ParserError
      return render json: { error: "Invalid json" }, status: :bad_request
    end

    logs, error = RestaurantImportService.new(file_data).call

    return render json: { error: error, menu_items_logs: logs }, status: :bad_request if error

    render json: { menu_items_logs: logs }, status: :ok
  end

  # GET /restaurants/1
  def show
    render json: @restaurant
  end

  # POST /restaurants
  def create
    @restaurant = Restaurant.new(restaurant_params)

    if @restaurant.save
      render json: @restaurant, status: :created, location: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      render json: @restaurant
    else
      render json: @restaurant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.expect(restaurant: [ :name, :address ])
    end

    def check_file
      @file = params[:file]
    end
end
