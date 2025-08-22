menu1 = Menu.create!(name: "Lunch")
menu2 = Menu.create!(name: "Dinner")

menu1.menu_items.create!(name: "Burger", price: 9.00)
menu1.menu_items.create!(name: "Small Salad", price: 5.00)

menu1.menu_items.create!(name: "Burger", price: 15.00)
menu1.menu_items.create!(name: "Large Salad", price: 8.00)
