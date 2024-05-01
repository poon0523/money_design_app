class HouseholdStandard < ApplicationRecord
    # バリデーションの設定
    validates :marital_status,           inclusion:{in:[true,false]}
    validates :children_number,          presence: true
    validates :expense_ratio_to_revenue, presence: true
    # アソシエーションの設定
    belongs_to :expense_revenue_item
end
