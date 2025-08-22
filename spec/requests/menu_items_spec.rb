require 'rails_helper'

RSpec.describe "MenuItems API", type: :request do
  let!(:menu) { create(:menu) }
  let!(:item) { create(:menu_item, menu: menu, name: "Pizza", price: 30.00) }

  describe "GET /menu_items" do
    it "return all items" do
      get "/menu_items"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.first["name"]).to eq("Pizza")
    end
  end

  describe "GET /menu_items/:id" do
    it "return item by id" do
      get "/menu_items/#{item.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["price"]).to eq("30.0")
    end
  end
end
