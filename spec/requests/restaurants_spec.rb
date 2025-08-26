require 'rails_helper'

RSpec.describe "Restaurants API", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Restaurante Central") }
  let!(:menu1) { create(:menu, restaurant: restaurant, name: "Almoço") }
  let!(:menu2) { create(:menu, restaurant: restaurant, name: "Jantar") }
  let!(:item) { create(:menu_item, name: "Pizza", price: 40) }

  before do
    menu1.menu_items << item
    menu2.menu_items << item
  end

  describe "GET /restaurants" do
    it "returns all restaurants with menus and menu items" do
      get "/restaurants"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)["restaurants"]

      expect(json.first["name"]).to eq("Restaurante Central")
      expect(json.first["menus"].map { |m| m["name"] }).to contain_exactly("Almoço", "Jantar")
      expect(json.first["menus"].first["menu_items"].first["name"]).to eq("Pizza")
    end
  end

  describe "GET /restaurants/:id" do
    it "returns a restaurant by id with menus and menu items" do
      get "/restaurants/#{restaurant.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Restaurante Central")
      expect(json["menus"].map { |m| m["name"] }).to contain_exactly("Almoço", "Jantar")
      expect(json["menus"].first["menu_items"].first["name"]).to eq("Pizza")
    end
  end
end
