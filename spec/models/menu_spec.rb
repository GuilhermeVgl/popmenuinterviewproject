require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe "associations" do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_items_menus).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_items_menus) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
