# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_04_13_100558) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "child_educations", force: :cascade do |t|
    t.bigint "child_id", null: false
    t.bigint "education_expense_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_child_educations_on_child_id"
    t.index ["education_expense_id"], name: "index_child_educations_on_education_expense_id"
  end

  create_table "children", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "birth_order"
    t.integer "birth_year_month_day"
    t.integer "nursery_school_start_age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "kindergarten_start_age"
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "education_expenses", force: :cascade do |t|
    t.integer "education_institution_type", default: 0, null: false
    t.integer "management_organization", default: 0, null: false
    t.integer "university_major", default: 0, null: false
    t.integer "annual_expense", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "boarding_house", default: 0, null: false
  end

  create_table "expense_revenue_amounts", force: :cascade do |t|
    t.bigint "expense_revenue_item_id", null: false
    t.bigint "household_id", null: false
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_revenue_item_id"], name: "index_expense_revenue_amounts_on_expense_revenue_item_id"
    t.index ["household_id"], name: "index_expense_revenue_amounts_on_household_id"
  end

  create_table "expense_revenue_items", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_expense_revenue_items_on_category_id"
  end

  create_table "household_standards", force: :cascade do |t|
    t.boolean "marital_status", default: false, null: false
    t.integer "children_number", default: 0, null: false
    t.bigint "expense_revenue_item_id", null: false
    t.float "expense_ratio_to_revenue", default: 0.0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["expense_revenue_item_id"], name: "index_household_standards_on_expense_revenue_item_id"
  end

  create_table "households", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: "YYYYMMDD家計状況(Ver.0)", null: false
    t.index ["user_id"], name: "index_households_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "household_id", null: false
    t.float "best_annual_interest_rate"
    t.float "worst_annual_interest_rate"
    t.integer "car_properties_present_value"
    t.integer "housing_properties_present_value"
    t.integer "other_properties_present_value"
    t.integer "car_present_loan_balance"
    t.integer "housing_present_loan_balance"
    t.integer "other_present_loan_balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "car_annual_residual_value_rate", default: 1.0
    t.float "housing_annual_residual_value_rate", default: 1.0
    t.float "other_annual_residual_value_rate", default: 1.0
    t.float "car_loan_interest_rate", default: 0.01
    t.float "housing_loan_interest_rate", default: 0.01
    t.float "other_loan_interest_rate", default: 0.01
    t.index ["household_id"], name: "index_properties_on_household_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.integer "age", default: 20, null: false
    t.boolean "marital_status", default: false, null: false
    t.integer "spouse_age"
    t.integer "children_number", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "child_educations", "children"
  add_foreign_key "child_educations", "education_expenses"
  add_foreign_key "children", "users"
  add_foreign_key "expense_revenue_amounts", "expense_revenue_items"
  add_foreign_key "expense_revenue_amounts", "households"
  add_foreign_key "expense_revenue_items", "categories"
  add_foreign_key "household_standards", "expense_revenue_items"
  add_foreign_key "households", "users"
  add_foreign_key "properties", "households"
end
