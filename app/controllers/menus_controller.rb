class MenusController < ApplicationController
  def index
    menus = Menu.includes(:menu_items, :restaurant).all
    render json: format_menus(menus)
  end

  def show
    menu = Menu.includes(:menu_items, :restaurant).find(params[:id])
    render json: format_menu(menu)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Menu not found" }, status: :not_found
  end

  private

  def format_menus(menus)
    {
      menus: menus.map { |m| format_menu(m) }
    }
  end

  def format_menu(menu)
    {
      name: menu.name,
      restaurant: { name: menu.restaurant.name },
      menu_items: menu.menu_items.map do |item|
        { name: item.name, price: item.price.to_f }
      end
    }
  end
end
