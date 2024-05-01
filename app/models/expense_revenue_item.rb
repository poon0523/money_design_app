class ExpenseRevenueItem < ApplicationRecord
  # バリデーションの設定
  validates :name, presence: true
  
  # アソシエーションの設定
  belongs_to :category
  has_many :household_standard, dependent: :destroy
  has_many :expense_revenue_amounts, dependent: :destroy
  has_many :households, through: :expense_revenue_amounts, dependent: :destroy
end
