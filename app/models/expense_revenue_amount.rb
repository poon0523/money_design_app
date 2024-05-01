class ExpenseRevenueAmount < ApplicationRecord
  # バリデーションの設定
  validates :amount, presence: true

  # アソシエーションの設定
  belongs_to :expense_revenue_item
  belongs_to :household
end
