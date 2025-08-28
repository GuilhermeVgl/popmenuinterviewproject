class MenuItemsController < ApplicationController
  def index
    menu_items = MenuItem.includes(menus: :restaurant).all
    render json: format_menu_items(menu_items)
  end

  def show
    menu_item = MenuItem.includes(menus: :restaurant).find(params[:id])
    render json: format_menu_item(menu_item)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "MenuItem not found" }, status: :not_found
  end

  private

  def format_menu_items(menu_items)
    {
      menu_items: menu_items.map { |m| format_menu_item(m) }
    }
  end


  def format_menu_item(item)
    {
      id: item.id,
      name: item.name,
      price: item.price.to_f,
      menu_ids: item.menus.pluck(:id)
    }
  end
end
