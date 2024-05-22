FactoryBot.define do
  factory :household_standard do
    marital_status { true }
    children_number { 2 }
    expense_ratio_to_revenue { 0.3 }

    expense_revenue_item   
  end
end
