# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create!([
    { category: "収入" },
    { category: "固定費" },
    { category: "変動費" }
])

ExpenseRevenueItem.create!([
    { name: "世帯収入", category_id: 1 },
    { name: "住居費", category_id: 2 },
    { name: "水道光熱費", category_id: 2 },
    { name: "社会保険料", category_id: 2 },
    { name: "生命保険料", category_id: 2 },
    { name: "通信費", category_id: 2 },
    { name: "教育費", category_id: 2 },
    { name: "サブスクリプション費", category_id: 2 },
    { name: "食費", category_id: 3 },
    { name: "日用品費", category_id: 3 },
    { name: "被服費", category_id: 3 },
    { name: "美容費", category_id: 3 },
    { name: "医療費", category_id: 3 },
    { name: "交通費", category_id: 3 },
    { name: "ガソリン費", category_id: 3 },
    { name: "積立投資額", category_id: 2 },
    { name: "定期預金額", category_id: 2 },
    { name: "ローン返済額（車）", category_id: 2 },
    { name: "ローン返済額（住宅）", category_id: 2 },
    { name: "ローン返済額（その他）", category_id: 2 }
])

EducationExpense.create!([
    # <公立>--------------------------------
    { education_institution_type: 1, management_organization: 1, university_major: 0, annual_expense: 20000, boarding_house: 0},
    { education_institution_type: 2, management_organization: 1, university_major: 0, annual_expense: 10000, boarding_house: 0},    
    { education_institution_type: 3, management_organization: 1, university_major: 0, annual_expense: 3000, boarding_house: 0},
    { education_institution_type: 4, management_organization: 1, university_major: 0, annual_expense: 4000, boarding_house: 0},
    { education_institution_type: 5, management_organization: 1, university_major: 0, annual_expense: 5000, boarding_house: 0},
    # 理系（下宿あり）
    { education_institution_type: 6, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 1},
    { education_institution_type: 7, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 1},
    { education_institution_type: 8, management_organization: 1, university_major: 1, annual_expense: 100000, boarding_house: 1},
    # 理系（下宿無し）
    { education_institution_type: 6, management_organization: 1, university_major: 1, annual_expense: 30000, boarding_house: 0},
    { education_institution_type: 7, management_organization: 1, university_major: 1, annual_expense: 30000, boarding_house: 0},
    { education_institution_type: 8, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 0},
    # 文系（下宿あり）
    { education_institution_type: 6, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { education_institution_type: 7, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { education_institution_type: 8, management_organization: 1, university_major: 2, annual_expense: 100000, boarding_house: 1},
    # 文系（下宿無し）
    { education_institution_type: 6, management_organization: 1, university_major: 2, annual_expense: 30000, boarding_house: 0},
    { education_institution_type: 7, management_organization: 1, university_major: 2, annual_expense: 30000, boarding_house: 0},
    { education_institution_type: 8, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 0},

    # <私立>--------------------------------
    { education_institution_type: 1, management_organization: 2, university_major: 0, annual_expense: 60000, boarding_house: 0},
    { education_institution_type: 2, management_organization: 2, university_major: 0, annual_expense: 30000, boarding_house: 0},    
    { education_institution_type: 3, management_organization: 2, university_major: 0, annual_expense: 30000, boarding_house: 0},
    { education_institution_type: 4, management_organization: 2, university_major: 0, annual_expense: 40000, boarding_house: 0},
    { education_institution_type: 5, management_organization: 2, university_major: 0, annual_expense: 50000, boarding_house: 0},
    # 理系（下宿あり）
    { education_institution_type: 6, management_organization: 2, university_major: 1, annual_expense: 130000, boarding_house: 1},
    { education_institution_type: 7, management_organization: 2, university_major: 1, annual_expense: 150000, boarding_house: 1},
    { education_institution_type: 8, management_organization: 2, university_major: 1, annual_expense: 170000, boarding_house: 1},
    # 理系（下宿無し）
    { education_institution_type: 6, management_organization: 2, university_major: 1, annual_expense: 80000, boarding_house: 0},
    { education_institution_type: 7, management_organization: 2, university_major: 1, annual_expense: 100000, boarding_house: 0},
    { education_institution_type: 8, management_organization: 2, university_major: 1, annual_expense: 120000, boarding_house: 0},
    # 文系（下宿あり）
    { education_institution_type: 6, management_organization: 2, university_major: 2, annual_expense: 110000, boarding_house: 1},
    { education_institution_type: 7, management_organization: 2, university_major: 2, annual_expense: 130000, boarding_house: 1},
    { education_institution_type: 8, management_organization: 2, university_major: 2, annual_expense: 150000, boarding_house: 1},
    # 文系（下宿なし）
    { education_institution_type: 6, management_organization: 2, university_major: 2, annual_expense: 60000, boarding_house: 1},
    { education_institution_type: 7, management_organization: 2, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { education_institution_type: 8, management_organization: 2, university_major: 2, annual_expense: 100000, boarding_house: 1},
])


HouseholdStandard.create!([
    # 配偶者なし
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 2, expense_ratio_to_revenue: 0.3 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 3, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 4, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 5, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 6, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 7, expense_ratio_to_revenue: 0 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 8, expense_ratio_to_revenue: 0.015 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 9, expense_ratio_to_revenue: 0.2 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 10, expense_ratio_to_revenue: 0.015 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 11, expense_ratio_to_revenue: 0.015 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 12, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 13, expense_ratio_to_revenue: 0.01 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 14, expense_ratio_to_revenue: 0.03 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 15, expense_ratio_to_revenue: 0.03 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 16, expense_ratio_to_revenue: 0.05 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 17, expense_ratio_to_revenue: 0.05 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 18, expense_ratio_to_revenue: 0.05 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 19, expense_ratio_to_revenue: 0.05 },
    { marital_status: 0, children_number: 0, expense_revenue_item_id: 20, expense_ratio_to_revenue: 0.05 },

    # 配偶者あり、子どもなし
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 2, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 3, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 4, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 5, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 6, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 7, expense_ratio_to_revenue: 0 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 8, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 9, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 10, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 11, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 12, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 13, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 14, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 15, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 16, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 17, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 18, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 19, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 0, expense_revenue_item_id: 20, expense_ratio_to_revenue: 0.05 },

    # 配偶者あり、子ども1人
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 2, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 3, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 4, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 5, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 6, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 7, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 8, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 9, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 10, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 11, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 12, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 13, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 14, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 15, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 16, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 17, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 18, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 19, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 1, expense_revenue_item_id: 20, expense_ratio_to_revenue: 0.05 },

    # 配偶者あり、子ども2人
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 2, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 3, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 4, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 5, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 6, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 7, expense_ratio_to_revenue: 0.1 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 8, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 9, expense_ratio_to_revenue: 0.25 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 10, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 11, expense_ratio_to_revenue: 0.015 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 12, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 13, expense_ratio_to_revenue: 0.01 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 14, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 15, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 16, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 17, expense_ratio_to_revenue: 0.03 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 18, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 19, expense_ratio_to_revenue: 0.05 },
    { marital_status: 1, children_number: 2, expense_revenue_item_id: 20, expense_ratio_to_revenue: 0.05 },

])
