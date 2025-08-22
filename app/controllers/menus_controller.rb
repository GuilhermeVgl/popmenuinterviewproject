class MenusController < ApplicationController
  def index
    menus = Menu.includes(:menu_items).all
    render json: menus.to_json(include: :menu_items)
  end

  def show
    menu = Menu.find(params[:id])
    render json: menu.to_json(include: :menu_items)
  end
end
