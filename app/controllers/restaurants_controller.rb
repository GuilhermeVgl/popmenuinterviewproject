class RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.includes(menus: :menu_items).all
    render json: format_restaurants(restaurants)
  end

  def show
    restaurant = Restaurant.includes(menus: :menu_items).find(params[:id])
    render json: format_restaurant(restaurant)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Restaurant not found" }, status: :not_found
  end

  def import
    file = params[:file]
    unless file
      render json: { error: "File not provided" }, status: :bad_request
      return
    end

    begin
      json_data = JSON.parse(file.read)
      result = RestaurantDataImporter.call(json_data)
      render json: result.logs, status: result.success? ? :created : :unprocessable_entity
    rescue JSON::ParserError
      render json: { error: "Invalid JSON format" }, status: :bad_request
    rescue StandardError => e
      Rails.logger.error e.full_message
      render json: { error: "An internal error occurred. Please try again later." }, status: :internal_server_error
    end
  end

  private

  def format_restaurants(restaurants)
    { restaurants: restaurants.map { |r| format_restaurant(r) } }
  end

  def format_restaurant(restaurant)
    {
      name: restaurant.name,
      menus: restaurant.menus.map do |menu|
        {
          id: menu.id,
          name: menu.name,
          menu_items: menu.menu_items.map do |item|
            { id: item.id, name: item.name, price: item.price.to_f }
          end
        }
      end
    }
  end
end
