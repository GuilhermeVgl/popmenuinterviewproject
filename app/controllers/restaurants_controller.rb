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

  private

  def format_restaurants(restaurants)
    {
      restaurants: restaurants.map { |r| format_restaurant(r) }
    }
  end

  def format_restaurant(restaurant)
    {
      name: restaurant.name,
      menus: restaurant.menus.map do |menu|
        {
          name: menu.name,
          menu_items: menu.menu_items.map do |item|
            {
              name: item.name,
              price: item.price.to_f
            }
          end
        }
      end
    }
  end
end
