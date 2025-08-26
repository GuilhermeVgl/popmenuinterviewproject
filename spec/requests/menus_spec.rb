require 'rails_helper'

RSpec.describe "Menus API", type: :request do
  let!(:restaurant) { create(:restaurant, name: "Restaurante Central") }
  let!(:menu) { create(:menu, restaurant: restaurant, name: "Almoço") }
  let!(:item) { create(:menu_item, name: "Pizza", price: 40) }

  before do
    menu.menu_items << item
  end

  describe "GET /menus" do
    it "returns all menus with menu items and restaurant info" do
      get "/menus"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)["menus"]

      expect(json.first["name"]).to eq("Almoço")
      expect(json.first["restaurant"]["name"]).to eq("Restaurante Central")
      expect(json.first["menu_items"].first["name"]).to eq("Pizza")
      expect(json.first["menu_items"].first["price"]).to eq(40)
    end
  end

  describe "GET /menus/:id" do
    it "returns menu by id" do
      get "/menus/#{menu.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Almoço")
      expect(json["restaurant"]["name"]).to eq("Restaurante Central")
      expect(json["menu_items"].size).to eq(1)
    end
  end
end
