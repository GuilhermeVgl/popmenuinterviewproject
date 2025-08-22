require 'rails_helper'

RSpec.describe "Menus API", type: :request do
  let!(:menu) { create(:menu, name: "Lunch") }
  let!(:item) { create(:menu_item, menu: menu, name: "Burguer", price: 25.00) }

  describe "GET /menus" do
    it "return all menus" do
      get "/menus"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.first["name"]).to eq("Lunch")
      expect(json.first["menu_items"].first["name"]).to eq("Burguer")
    end
  end

  describe "GET /menus/:id" do
    it "return menu by id" do
      get "/menus/#{menu.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["name"]).to eq("Lunch")
      expect(json["menu_items"].size).to eq(1)
    end
  end
end
