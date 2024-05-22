FactoryBot.define do
  factory :expense_revenue_item1, class: ExpenseRevenueAmount do
    expense_revenue_item_id {1}
    amount { 600000 }
    household
  end

  factory :expense_revenue_item2, class: ExpenseRevenueAmount do
    expense_revenue_item_id {2}
    amount { 100000 }
    household
  end

  factory :expense_revenue_item3, class: ExpenseRevenueAmount do
    expense_revenue_item_id {3}
    amount { 10000 }
    household
  end

  factory :expense_revenue_item4, class: ExpenseRevenueAmount do
    expense_revenue_item_id {4}
    amount { 20000 }
    household
  end

  factory :expense_revenue_item5, class: ExpenseRevenueAmount do
    expense_revenue_item_id {5}
    amount { 10000 }
    household
  end

  factory :expense_revenue_item6, class: ExpenseRevenueAmount do
    expense_revenue_item_id {6}
    amount { 10000 }
    household
  end

  #子ども1人想定での教育費を教育費マスタから引用
  factory :expense_revenue_item7, class: ExpenseRevenueAmount do
    expense_revenue_item_id {7}
    amount { 1666 }
    household
  end

  factory :expense_revenue_item8, class: ExpenseRevenueAmount do
    expense_revenue_item_id {8}
    amount { 5000 }
    household
  end

  factory :expense_revenue_item9, class: ExpenseRevenueAmount do
    expense_revenue_item_id {9}
    amount { 50000 }
    household
  end

  factory :expense_revenue_item10, class: ExpenseRevenueAmount do
    expense_revenue_item_id {10}
    amount { 10000 }
    household
  end

  factory :expense_revenue_item11, class: ExpenseRevenueAmount do
    expense_revenue_item_id {11}
    amount { 20000 }
    household
  end

  factory :expense_revenue_item12, class: ExpenseRevenueAmount do
    expense_revenue_item_id {12}
    amount { 10000 }
    household
  end

  factory :expense_revenue_item13, class: ExpenseRevenueAmount do
    expense_revenue_item_id {13}
    amount { 10000 }
    household
  end

  factory :expense_revenue_item14, class: ExpenseRevenueAmount do
    expense_revenue_item_id {14}
    amount { 20000 }
    household
  end

  factory :expense_revenue_item15, class: ExpenseRevenueAmount do
    expense_revenue_item_id {15}
    amount { 20000 }
    household
  end

  factory :expense_revenue_item16, class: ExpenseRevenueAmount do
    expense_revenue_item_id {16}
    amount { 30000 }
    household
  end

  factory :expense_revenue_item17, class: ExpenseRevenueAmount do
    expense_revenue_item_id {17}
    amount { 20000 }
    household
  end

  factory :expense_revenue_item18, class: ExpenseRevenueAmount do
    expense_revenue_item_id {18}
    amount { 30000 }
    household
  end

  factory :expense_revenue_item19, class: ExpenseRevenueAmount do
    expense_revenue_item_id {19}
    amount { 0 }
    household
  end

  factory :expense_revenue_item20, class: ExpenseRevenueAmount do
    expense_revenue_item_id {20}
    amount { 20000 }
    household
  end



end
