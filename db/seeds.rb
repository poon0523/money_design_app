# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# a.マスタ系のseed登録
# a-1.カテゴリ
Category.create!([
    { category: "収入" },
    { category: "固定費" },
    { category: "変動費" }
])

# a-2.収支項目
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

# a-3.教育費
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
    { education_institution_type: 6, management_organization: 2, university_major: 2, annual_expense: 60000, boarding_house: 0},
    { education_institution_type: 7, management_organization: 2, university_major: 2, annual_expense: 80000, boarding_house: 0},
    { education_institution_type: 8, management_organization: 2, university_major: 2, annual_expense: 100000, boarding_house: 0},
])

# a-4.家計基準
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

# b.トランザクション系のseed登録
# b-1.ユーザー
User.create!([
    { name:"general1_sample", email: "general1_sample@abc.com", password: "general1_sample", password_confirmation: "general1_sample", admin: "false", age: "35", marital_status: "true",spouse_age: "25", children_number: "0"},
    { name:"general2_sample", email: "general2_sample@abc.com", password: "general2_sample", password_confirmation: "general2_sample", admin: "false", age: "40", marital_status: "true",spouse_age: "35", children_number: "1"},
    { name:"general3_sample", email: "general3_sample@abc.com", password: "general3_sample", password_confirmation: "general3_sample", admin: "false", age: "25", marital_status: "true",spouse_age: "40", children_number: "2"},
    { name:"admin1_sample", email: "admin1_sample@abc.com", password: "admin1_sample", password_confirmation: "admin1_sample", admin: "true", age: "35", marital_status: "true",spouse_age: "25", children_number: "2"},
    { name:"admin2_sample", email: "admin2_sample@abc.com", password: "admin2_sample", password_confirmation: "admin2_sample", admin: "true", age: "45", marital_status: "true",spouse_age: "30", children_number: "1"}
])

# b-2.（ユーザーに紐づく）子ども情報
# 子持ちのユーザーのidを取得
# (1)一般ユーザー-子ども1人
user1 = User.find_by(email: "general2_sample@abc.com").id
# (2)一般ユーザー-子ども2人
user2 = User.find_by(email: "general3_sample@abc.com").id
# (3)管理者ユーザー-子ども2人
user3 = User.find_by(email: "admin1_sample@abc.com").id
# (4)管理者ユーザー-子ども1人
user4 = User.find_by(email: "admin2_sample@abc.com").id
# (1)~(4)の子ども情報の登録
Child.create!([
    # user1の子どもの1人分
    { user_id: user1, birth_order: "1", birth_year_month_day: "20250205", nursery_school_start_age: "1", kindergarten_start_age: "4" },
    # user2の子どもの2人分
    { user_id: user2, birth_order: "1", birth_year_month_day: "20251205", nursery_school_start_age: "1", kindergarten_start_age: "4" },
    { user_id: user2, birth_order: "2", birth_year_month_day: "20271205", nursery_school_start_age: "1", kindergarten_start_age: "4" },
    # user3の子どもの2人分
    { user_id: user3, birth_order: "1", birth_year_month_day: "20251005", nursery_school_start_age: "1", kindergarten_start_age: "4" },
    { user_id: user3, birth_order: "2", birth_year_month_day: "20281105", nursery_school_start_age: "1", kindergarten_start_age: "4" },
    # user4の子どもの1人分
    { user_id: user4, birth_order: "1", birth_year_month_day: "20240205", nursery_school_start_age: "1", kindergarten_start_age: "4" }
])

# b-3.子どもの教育情報
# 登録済みの子どもの教育情報を保育園~大学まで登録する
# seedデータでは全子どもの保育園～大学までの教育方針を同じに設定するので、以下の通り、EducationExpenseから保育園～大学に該当するidを定義しておく
nuesary_id = EducationExpense.find_by(education_institution_type: 1, management_organization: 1, university_major: 0, annual_expense: 20000, boarding_house: 0).id
kindergarten_id = EducationExpense.find_by(education_institution_type: 2, management_organization: 1, university_major: 0, annual_expense: 10000, boarding_house: 0).id
primary_school_id = EducationExpense.find_by(education_institution_type: 3, management_organization: 1, university_major: 0, annual_expense: 3000, boarding_house: 0).id
junior_school_id = EducationExpense.find_by(education_institution_type: 4, management_organization: 1, university_major: 0, annual_expense: 4000, boarding_house: 0).id
high_school_id = EducationExpense.find_by(education_institution_type: 5, management_organization: 1, university_major: 0, annual_expense: 5000, boarding_house: 0).id
university_id = EducationExpense.find_by(education_institution_type: 7, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 1).id
# user1の子どもの1人分
user1_child1 = User.find_by(email: "general2_sample@abc.com").children.first.id
ChildEducation.create!([
    { child_id: user1_child1, education_expense_id: nuesary_id },
    { child_id: user1_child1, education_expense_id: kindergarten_id },
    { child_id: user1_child1, education_expense_id: primary_school_id },
    { child_id: user1_child1, education_expense_id: junior_school_id },
    { child_id: user1_child1, education_expense_id: high_school_id },
    { child_id: user1_child1, education_expense_id: university_id },
])

# user2の子どもの2人分
user2_child1 = User.find_by(email: "general3_sample@abc.com").children.first.id
user2_child2 = User.find_by(email: "general3_sample@abc.com").children.second.id
ChildEducation.create!([
    { child_id: user2_child1, education_expense_id: nuesary_id },
    { child_id: user2_child1, education_expense_id: kindergarten_id },
    { child_id: user2_child1, education_expense_id: primary_school_id },
    { child_id: user2_child1, education_expense_id: junior_school_id },
    { child_id: user2_child1, education_expense_id: high_school_id },
    { child_id: user2_child1, education_expense_id: university_id },
])
ChildEducation.create!([
    { child_id: user2_child2, education_expense_id: nuesary_id },
    { child_id: user2_child2, education_expense_id: kindergarten_id },
    { child_id: user2_child2, education_expense_id: primary_school_id },
    { child_id: user2_child2, education_expense_id: junior_school_id },
    { child_id: user2_child2, education_expense_id: high_school_id },
    { child_id: user2_child2, education_expense_id: university_id },
])

# user3の子どもの1人分
user3_child1 = User.find_by(email: "admin1_sample@abc.com").children.first.id
user3_child2 = User.find_by(email: "admin1_sample@abc.com").children.second.id
ChildEducation.create!([
    { child_id: user3_child1, education_expense_id: nuesary_id },
    { child_id: user3_child1, education_expense_id: kindergarten_id },
    { child_id: user3_child1, education_expense_id: primary_school_id },
    { child_id: user3_child1, education_expense_id: junior_school_id },
    { child_id: user3_child1, education_expense_id: high_school_id },
    { child_id: user3_child1, education_expense_id: university_id },
])
ChildEducation.create!([
    { child_id: user3_child2, education_expense_id: nuesary_id },
    { child_id: user3_child2, education_expense_id: kindergarten_id },
    { child_id: user3_child2, education_expense_id: primary_school_id },
    { child_id: user3_child2, education_expense_id: junior_school_id },
    { child_id: user3_child2, education_expense_id: high_school_id },
    { child_id: user3_child2, education_expense_id: university_id },
])

# user4の子どもの1人分
user4_child1 = User.find_by(email: "admin2_sample@abc.com").children.first.id
ChildEducation.create!([
    { child_id: user4_child1, education_expense_id: nuesary_id },
    { child_id: user4_child1, education_expense_id: kindergarten_id },
    { child_id: user4_child1, education_expense_id: primary_school_id },
    { child_id: user4_child1, education_expense_id: junior_school_id },
    { child_id: user4_child1, education_expense_id: high_school_id },
    { child_id: user4_child1, education_expense_id: university_id },
])

# b-4.（ユーザーに紐づく）家計状況情報
# user1~4の家計状況情報を作成（※titleはデフォルト値で登録）
Household.create!([
    { user_id: User.find_by(email: "general1_sample@abc.com").id },
    { user_id: User.find_by(email: "general2_sample@abc.com").id },
    { user_id: User.find_by(email: "general3_sample@abc.com").id },
    { user_id: User.find_by(email: "admin1_sample@abc.com").id },
    { user_id: User.find_by(email: "admin2_sample@abc.com").id },
])



# b-5.（家計状況に紐づく）各収支項目の金額
# user0~user4の各収支項目の金額を0円で登録
# 全収支項目のidを取得するため、ExpenseRevunueItemテーブルにある全idを配列として取得
expense_revenue_item_id_list = Household.get_expense_revenue_items_order_category
# user0の収支項目金額登録
expense_revenue_item_id_list.each do |expense_revenue_item|
    User.find_by(email: "general1_sample@abc.com").households.first.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
end

# user1の収支項目金額登録
expense_revenue_item_id_list.each do |expense_revenue_item|
    User.find_by(email: "general2_sample@abc.com").households.first.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
end

# user2の収支項目金額登録
expense_revenue_item_id_list.each do |expense_revenue_item|
    User.find_by(email: "general3_sample@abc.com").households.first.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
end

# user3の収支項目金額登録
expense_revenue_item_id_list.each do |expense_revenue_item|
    User.find_by(email: "admin1_sample@abc.com").households.first.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
end

# user4の収支項目金額登録
expense_revenue_item_id_list.each do |expense_revenue_item|
    User.find_by(email: "admin2_sample@abc.com").households.first.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
end


# b-6.（家計状況に紐づく）資産状況情報
# user0~4の家計状況に紐づく資産状況情報を登録する
Property.create!([
    { household_id: User.find_by(email: "general1_sample@abc.com").households.first.id, 
    best_annual_interest_rate: 0.07,
    worst_annual_interest_rate: 0.03,
    car_properties_present_value: 5000000,
    housing_properties_present_value: 0,
    other_properties_present_value: 1000000,
    car_present_loan_balance: 4000000,
    housing_present_loan_balance: 0,
    other_present_loan_balance: 1000000,
    car_annual_residual_value_rate: 0.8,
    housing_annual_residual_value_rate: 0.7,
    other_annual_residual_value_rate: 0.9,
    car_loan_interest_rate: 0.015,
    housing_loan_interest_rate: 0,
    other_loan_interest_rate: 0.05,},

    { household_id: User.find_by(email: "general2_sample@abc.com").households.first.id,
    best_annual_interest_rate: 0.07,
    worst_annual_interest_rate: 0.03,
    car_properties_present_value: 5000000,
    housing_properties_present_value: 0,
    other_properties_present_value: 1000000,
    car_present_loan_balance: 4000000,
    housing_present_loan_balance: 0,
    other_present_loan_balance: 1000000,
    car_annual_residual_value_rate: 0.8,
    housing_annual_residual_value_rate: 0.7,
    other_annual_residual_value_rate: 0.9,
    car_loan_interest_rate: 0.015,
    housing_loan_interest_rate: 0,
    other_loan_interest_rate: 0.05,},

    { household_id: User.find_by(email: "general3_sample@abc.com").households.first.id,
    best_annual_interest_rate: 0.07,
    worst_annual_interest_rate: 0.03,
    car_properties_present_value: 5000000,
    housing_properties_present_value: 0,
    other_properties_present_value: 1000000,
    car_present_loan_balance: 4000000,
    housing_present_loan_balance: 0,
    other_present_loan_balance: 1000000,
    car_annual_residual_value_rate: 0.8,
    housing_annual_residual_value_rate: 0.7,
    other_annual_residual_value_rate: 0.9,
    car_loan_interest_rate: 0.015,
    housing_loan_interest_rate: 0,
    other_loan_interest_rate: 0.05,},

    { household_id: User.find_by(email: "admin1_sample@abc.com").households.first.id,
    best_annual_interest_rate: 0.07,
    worst_annual_interest_rate: 0.03,
    car_properties_present_value: 5000000,
    housing_properties_present_value: 0,
    other_properties_present_value: 1000000,
    car_present_loan_balance: 4000000,
    housing_present_loan_balance: 0,
    other_present_loan_balance: 1000000,
    car_annual_residual_value_rate: 0.8,
    housing_annual_residual_value_rate: 0.7,
    other_annual_residual_value_rate: 0.9,
    car_loan_interest_rate: 0.015,
    housing_loan_interest_rate: 0,
    other_loan_interest_rate: 0.05,},

    { household_id: User.find_by(email: "admin2_sample@abc.com").households.first.id,
    best_annual_interest_rate: 0.07,
    worst_annual_interest_rate: 0.03,
    car_properties_present_value: 5000000,
    housing_properties_present_value: 0,
    other_properties_present_value: 1000000,
    car_present_loan_balance: 4000000,
    housing_present_loan_balance: 0,
    other_present_loan_balance: 1000000,
    car_annual_residual_value_rate: 0.8,
    housing_annual_residual_value_rate: 0.7,
    other_annual_residual_value_rate: 0.9,
    car_loan_interest_rate: 0.015,
    housing_loan_interest_rate: 0,
    other_loan_interest_rate: 0.05,}
])


