require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Test Restaurant") }
  let!(:menu1) { create(:menu, restaurant: restaurant, name: "Lunch") }
  let!(:menu2) { create(:menu, restaurant: restaurant, name: "Dinner") }
  let!(:item) { create(:menu_item, name: "Pizza", price: 40) }

  before do
    menu1.menu_items << item
    menu2.menu_items << item
  end

  describe "GET /menu_items" do
    it "returns all menu items with menus and restaurant info" do
      get "/menu_items"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body, symbolize_names: true)
      
      first_item = json[:menu_items].first

      expect(first_item[:id]).to eq(item.id)
      expect(first_item[:name]).to eq("Pizza")
      expect(first_item[:price]).to eq(40)
      expect(first_item[:menu_ids]).to match_array([menu1.id, menu2.id])
    end
  end

  describe "GET /menu_items/:id" do
    it "returns menu item by id" do
      get "/menu_items/#{item.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["id"]).to eq(item.id)
      expect(json["name"]).to eq("Pizza")
      expect(json["price"]).to eq(40)
      expect(json["menu_ids"]).to match_array([menu1.id, menu2.id])
    end
  end
end
