class Menu < ApplicationRecord
    belongs_to :Restaurant    
    has_many :menu_items, dependent: :destroy

    validates :name, presence: true
end
