class Category < ApplicationRecord
    # バリデーションの設定
    validates :category, presence: true
    # アソシエーションの設定
    has_many :expense_revenue_items, dependent: :destroy
end
