class MenusController < ApplicationController
  def index
    menus = Menu.all
    render json: menus
  end

  def show
    menus = Menu.find(params[:id])
    render json: menus
  end
end
