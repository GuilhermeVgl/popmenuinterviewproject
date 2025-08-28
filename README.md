# 🍽 Restaurant Menu Management API

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/your-repo)
[![Tests](https://img.shields.io/badge/tests-rspec-blue)](https://github.com/your-repo)
[![License](https://img.shields.io/badge/license-MIT-lightgrey)](LICENSE)

A RESTful API built with **Rails 8** to manage restaurants, menus, and menu items. Supports JSON bulk import, validations, and structured endpoints for querying all data.

---

## **Features**

* **Restaurants**

  * Multiple menus per restaurant
* **Menus**

  * Multiple menu items per menu
  * Belongs to a restaurant
* **Menu Items**

  * Unique names per restaurant
  * Belongs to multiple menus
  * Price must be ≥ 0
* **JSON Import**

  * Bulk import restaurants, menus, and items
  * Logs successes and failures
* **Error Handling**

  * Validates JSON format and required fields
  * Returns structured errors for invalid input or internal errors

---

## **API Endpoints**

| Method | Endpoint          | Description                                   |
| ------ | ----------------- | --------------------------------------------- |
| GET    | /restaurants      | List all restaurants with menus and items     |
| GET    | /restaurants/\:id | Get a single restaurant                       |
| GET    | /menus            | List all menus with items and restaurant      |
| GET    | /menus/\:id       | Get a single menu                             |
| GET    | /menu\_items      | List all menu items with menus and restaurant |
| GET    | /menu\_items/\:id | Get a single menu item                        |
| POST   | /imports          | Import restaurants, menus, and items via JSON |

---

## **JSON Import Example**

```json
{
  "restaurants": [
    {
      "name": "Joe Cafe",
      "menus": [
        {
          "name": "Lunch",
          "menu_items": [
            { "name": "Burger", "price": 25.0 },
            { "name": "Salad", "price": 18.0 }
          ]
        },
        {
          "name": "Dinner",
          "menu_items": [
            { "name": "Pizza", "price": 40.0 }
          ]
        }
      ]
    }
  ]
}
```

**Request Example:**

```bash
curl -X POST "http://localhost:3000/imports" \
  -F "file=@restaurant_data.json"
```

**Response Example:**

```json
[
  "SUCCESS: Item 'Burger' imported into menu 'Lunch'.",
  "SUCCESS: Item 'Pizza' imported into menu 'Dinner'."
]
```

---

## **Getting Started**

### **Requirements**

* Ruby 3.x
* Rails 8.x
* PostgreSQL (or any preferred DB)
* Bundler

### **Setup**

```bash
git clone https://github.com/GuilhermeVgl/popmenuinterviewproject.git
cd popmenuinterviewproject
bundle install
rails db:create db:migrate
rails server
```

### **Run Tests**

```bash
bundle exec rspec -f doc
```

---

## **Testing & Documentation**

* **RSpec** for models, request specs, and service objects
* Use your existing RSpec tests to validate endpoints and JSON import functionality
* All endpoints return structured JSON responses and appropriate HTTP status codes

---

## **Extensibility**

* Modular and service-oriented design
* Easy to add new fields or features to menus, items, or restaurants
* Handles alternative JSON keys (`menu_items` or `dishes`)
* Designed for scalability and maintainability
