require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Restaurante Central") }
  let!(:menu1) { create(:menu, restaurant: restaurant, name: "Almoço") }
  let!(:menu2) { create(:menu, restaurant: restaurant, name: "Jantar") }
  let!(:item) { create(:menu_item, name: "Pizza", price: 40) }

  before do
    menu1.menu_items << item
    menu2.menu_items << item
  end

  describe "GET /menu_items" do
    it "returns all menu items with menus and restaurant info" do
      get "/menu_items"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)["menu_items"]

      expect(json.first["name"]).to eq("Pizza")
      expect(json.first["price"]).to eq(40)
      expect(json.first["menus"].size).to eq(2)
      expect(json.first["menus"].first["restaurant"]["name"]).to eq("Restaurante Central")
    end
  end

  describe "GET /menu_items/:id" do
    it "returns menu item by id" do
      get "/menu_items/#{item.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Pizza")
      expect(json["price"]).to eq(40)
      expect(json["menus"].map { |m| m["name"] }).to contain_exactly("Almoço", "Jantar")
    end
  end
end
