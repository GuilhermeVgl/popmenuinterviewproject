require 'rails_helper'

RSpec.describe RestaurantDataImporter, type: :service do
  describe '.call' do
    context 'with valid JSON and empty database' do
      let(:valid_data) do
        {
          'restaurants' => [
            {
              'name' => 'Joe Cafe',
              'menus' => [
                {
                  'name' => 'Lunch',
                  'menu_items' => [
                    { 'name' => 'Burger', 'price' => 25.0 },
                    { 'name' => 'Salad', 'price' => 18.0 }
                  ]
                },
                {
                  'name' => 'Dinner',
                  'menu_items' => [
                    { 'name' => 'Pizza', 'price' => 40.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'creates records correctly' do
        expect { described_class.call(valid_data) }
          .to change(Restaurant, :count).by(1)
          .and change(Menu, :count).by(2)
          .and change(MenuItem, :count).by(3)
      end

      it 'associates menus and items correctly' do
        described_class.call(valid_data)
        restaurant = Restaurant.find_by(name: 'Joe Cafe')
        lunch_menu = restaurant.menus.find_by(name: 'Lunch')

        expect(restaurant.menus.count).to eq(2)
        expect(lunch_menu.menu_items.count).to eq(2)
        expect(lunch_menu.menu_items.pluck(:name)).to contain_exactly('Burger', 'Salad')
      end

      it 'returns success result with logs' do
        result = described_class.call(valid_data)
        expect(result.success?).to be true
        expect(result.logs).to include("SUCCESS: Item 'Burger' imported into menu 'Lunch'.")
        expect(result.logs).to include("SUCCESS: Item 'Pizza' imported into menu 'Dinner'.")
      end
    end

    context 'when data already exists' do
      before do
        restaurant = Restaurant.create!(name: 'Joe Cafe')
        menu = restaurant.menus.create!(name: 'Lunch')
        menu.menu_items.create!(name: 'Burger', price: 20.0)
      end

      let(:update_data) do
        {
          'restaurants' => [
            {
              'name' => 'Joe Cafe',
              'menus' => [
                {
                  'name' => 'Lunch',
                  'menu_items' => [
                    { 'name' => 'Burger', 'price' => 22.50 },
                    { 'name' => 'Fries', 'price' => 12.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'does not duplicate existing records' do
        expect { described_class.call(update_data) }
          .to change(MenuItem, :count).by(1)

        expect(Restaurant.count).to eq(1)
        expect(Menu.count).to eq(1)
      end

      it 'updates attributes of existing records' do
        described_class.call(update_data)
        burger = MenuItem.find_by(name: 'Burger')
        expect(burger.reload.price).to eq(22.50)
      end
    end

    context 'with invalid data' do
      let(:invalid_data) do
        {
          'restaurants' => [
            {
              'name' => 'Ghost Restaurant',
              'menus' => [
                {
                  'name' => 'Broken Menu',
                  'menu_items' => [
                    { 'name' => 'Valid Item', 'price' => 10.0 },
                    { 'name' => 'Invalid Item', 'price' => -5.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'does not create records when validation fails' do
        expect { described_class.call(invalid_data) }
          .to not_change_counts
      end

      it 'returns failure result' do
        result = described_class.call(invalid_data)
        expect(result.success?).to be false
      end

      it 'returns failure logs with validation message' do
        result = described_class.call(invalid_data)
        expect(result.logs.first).to include("FAILURE while processing 'Ghost Restaurant'")
        expect(result.logs.first).to match(/must be greater than or equal to 0/)
      end
    end

    context 'with inconsistent JSON keys' do
      let(:inconsistent_data) do
        {
          'restaurants' => [
            {
              'name' => 'Flexible Restaurant',
              'menus' => [
                {
                  'name' => 'Menu with Dishes',
                  'dishes' => [
                    { 'name' => 'Chicken Wings', 'price' => 15.0 }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'imports items even with alternative keys' do
        described_class.call(inconsistent_data)
        item = MenuItem.find_by(name: 'Chicken Wings')
        expect(item).not_to be_nil
        expect(item.price).to eq(15.0)
      end
    end
  end
end

def not_change_counts
  change(Restaurant, :count).by(0)
    .and change(Menu, :count).by(0)
    .and change(MenuItem, :count).by(0)
end
