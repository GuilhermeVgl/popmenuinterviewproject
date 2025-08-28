class RestaurantDataImporter
  Result = Struct.new(:success?, :logs)

  def self.call(json_data)
    new(json_data).call
  end

  def initialize(json_data)
    @data = json_data['restaurants']
    @logs = []
  end

  def call
    @data.each { |restaurant_data| process_restaurant(restaurant_data) }
    success = @logs.none? { |log| log.start_with?("FAILURE") }
    Result.new(success, @logs)
  end

  private

    def process_restaurant(restaurant_data)
      transaction_logs = []

      ActiveRecord::Base.transaction do
          restaurant = Restaurant.find_or_initialize_by(name: restaurant_data['name'])
          restaurant.save!

          restaurant_data['menus']&.each do |menu_data|
            menu = restaurant.menus.find_or_initialize_by(name: menu_data['name'])
            menu.save!

            items_data = menu_data['menu_items'] || menu_data['dishes']
            items_data&.each do |item_data|
                process_menu_item(item_data, menu, transaction_logs)
            end
          end
      end
      @logs.concat(transaction_logs)
      rescue ActiveRecord::RecordInvalid => e
      @logs << "FAILURE while processing '#{restaurant_data['name']}': #{e.record.errors.full_messages.join(', ')}"
    end

    def process_menu_item(item_data, menu, logs)
      menu_item = MenuItem.find_or_initialize_by(name: item_data['name'])
      menu_item.price = item_data['price']
      menu_item.save!

      menu.menu_items << menu_item unless menu.menu_items.exists?(menu_item.id)
      logs << "SUCCESS: Item '#{menu_item.name}' imported into menu '#{menu.name}'."
    end
end
