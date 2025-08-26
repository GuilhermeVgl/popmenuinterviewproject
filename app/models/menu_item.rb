class MenuItem < ApplicationRecord
  has_many :menu_items_menus, dependent: :destroy
  has_many :menus, through: :menu_items_menus

  validates :name, :price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
