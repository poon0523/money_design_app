class Household < ApplicationRecord
    # バリデーションの設定
    validates :title, presence: true

    # アソシエーションの設定
    belongs_to :user
    has_many :expense_revenue_amounts, dependent: :destroy
    has_many :expense_revenue_items, through: :expense_revenue_amounts
    accepts_nested_attributes_for :expense_revenue_amounts, allow_destroy: true
    has_many :properties, dependent: :destroy

    # クラスメソッドの定義
    # 家計状況-詳細画面：標準月の収支比率算出
    scope :present_balance_ratio, -> (expense,revenue){(expense.to_f/revenue.to_f)*100}

    # 家計状況-詳細画面：expense_revenue_amountsテーブル（中間テーブル）をCategory_idとnameの昇順で並べる
    scope :order_expense_revenue_amounts, -> (household){ household.expense_revenue_amounts.joins(:expense_revenue_item).order("expense_revenue_items.category_id ASC","expense_revenue_items.name ASC") }

    # 家計状況-編集画面：expense_revenue_amountsテーブル（中間テーブル）をexpense_revenue_item_idの昇順で並べる
    scope :edit_order_expense_revenue_amounts, -> (household){ household.expense_revenue_amounts.joins(:expense_revenue_item).order("expense_revenue_items.id ASC") }

    # 家計状況-詳細画面：expense_revenue_itemsテーブル（中間テーブル）をCategory_idの昇順で並べかえて、expense_revenue_itemのidを取得する
    scope :get_expense_revenue_items_order_category, -> { ExpenseRevenueItem.order("expense_revenue_items.category_id ASC","expense_revenue_items.name ASC").select("id") }

    # インスタンスメソッドの定義
    # 資産状況のモデル、アクションで使用するメソッド
    # expense_revenue_amountsテーブルとexpense_revenue_itemテーブルを結合した上で指定の収支項目の金額を取得する
    # 任意のhouseholdに紐づくデータを抽出したいため、インスタンドメソッドとして作成
    def get_specific_expense_revenue_amount(item_name)
        return expense_revenue_amounts.joins(:expense_revenue_item).find_by(expense_revenue_item: {name: item_name}).amount
    end

    # 資産状況のモデル、アクションで使用するメソッド
    # expense_revenue_amountsテーブルとexpense_revenue_itemテーブルを結合する
    def joins_data_expense_revenue_amount_and_item(household)
        return household.expense_revenue_amounts.joins(:expense_revenue_item)
    end
end
