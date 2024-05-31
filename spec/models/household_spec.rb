require 'rails_helper'

RSpec.describe Household, type: :model do
  describe "バリデーション" do

    it "成功-タイトルが入力されている場合、家計情報の作成が有効であること" do
      household = FactoryBot.build(:household)
      expect(household).to be_valid
    end

    it "失敗-タイトルが入力されていない場合、家計情報の作成が無効であること" do
      household = FactoryBot.build(:household, title: "")
      expect(household).to be_invalid
    end
  end

  describe "クラスメソッド" do
    it "各支出項目の収支比率を算出するメソッド" do
      # (1)household、expense、revenueのテストデータを作成
      household = FactoryBot.build(:household)
      expense = FactoryBot.build(:expense_revenue_item1, household: household, amount: 50000)
      revenue = FactoryBot.build(:expense_revenue_item1, household: household, amount: 450000)
      # (2)テストで計算した結果と同じ結果がクラスメソッド「present_balance_ratio」で得られるかを確認する
      result_present_balance_ratio = Household.present_balance_ratio(expense.amount,revenue.amount)
      expect(result_present_balance_ratio).to eq (50000.to_f/450000.to_f)*100
    end

    it "expense_revenue_amountsテーブル（中間テーブル）をCategory_idの昇順で並べるメソッド" do
      # (1)householdのテストデータを作成
      household = FactoryBot.build(:household)
      # (2)categoryのテストデータを作成
      category1 = FactoryBot.create(:category)
      category2 = FactoryBot.create(:category, category: "test_category2")
      category3 = FactoryBot.create(:category, category: "test_category3")
      # (3)2で作成したcategoryを使ってexpense_revenue_itemのテストデータを作成
      expense_revenue_item1 = FactoryBot.create(:expense_revenue_item, category: category1)
      expense_revenue_item2 = FactoryBot.create(:expense_revenue_item, category: category2)
      expense_revenue_item3 = FactoryBot.create(:expense_revenue_item, category: category3)
      # (4)3で作成したexpense_revenue_itemを使ってhouseholdに紐づくexpense_revenue_amountのテストデータを作成
      # ※この後、category_idの昇順で並べ替えたことが確認できるようにexpense_revenue_amountはexpense_revenue_item3から順に登録する
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item3)
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item2)
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item1)
      # (5)category_idの昇順で並べ替えてない場合、expense_revenue_item3が配列の先頭にあることを確認
      expect(household.expense_revenue_amounts.first.expense_revenue_item_id).to eq expense_revenue_item3.id
      # (6)クラスメソッド「order_expense_revenue_amounts」を実行し、expense_revenue_item1が配列の先頭になったことを確認
      expect(Household.order_expense_revenue_amounts(household).first.expense_revenue_item_id).to eq expense_revenue_item1.id
    end
  end

  describe "インスタンスメソッド" do
    it "expense_revenue_amountsテーブルとexpense_revenue_itemテーブルを結合した上で指定の収支項目の金額を取得するメソッド" do
      # (1)householdのテストデータを作成
      household = FactoryBot.build(:household)
      # (2)expense_revenue_itemのテストデータを作成。指定する収支項目が区別できるように1つだけnameを異なる名前で上書き
      expense_revenue_item1 = FactoryBot.create(:expense_revenue_item, name: "target_item")
      expense_revenue_item2 = FactoryBot.create(:expense_revenue_item)
      expense_revenue_item3 = FactoryBot.create(:expense_revenue_item)
      # (3)2で作成したexpense_revenue_itemを使ってhouseholdに紐づくexpense_revenue_amountのテストデータを作成
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item1, amount: 30000)
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item2, amount: 5000)
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item3, amount: 2000)
      # (4)引数に金額を参照したい収支項目名を指定し、テストデータとして定義した金額と一致するかを確認
      expect(household.get_specific_expense_revenue_amount(expense_revenue_item1.name)).to eq 30000
    end

    it "expense_revenue_amountsテーブルとexpense_revenue_itemテーブルを結合するメソッド" do
      # (1)householdのテストデータを作成
      household = FactoryBot.build(:household)
      # (2)expense_revenue_itemのテストデータを作成
      # ※結合するデータと結合しないデータが区別できるよにnameを設定
      expense_revenue_item1 = FactoryBot.create(:expense_revenue_item, name: "join_target1")
      expense_revenue_item2 = FactoryBot.create(:expense_revenue_item, name: "join_target2")
      expense_revenue_item3 = FactoryBot.create(:expense_revenue_item, name: "not_join_target")
      # (3)2で作成したexpense_revenue_itemを使ってhouseholdに紐づくexpense_revenue_amountのテストデータを作成
      # ※expense_revenue_item3についてはexpense_revenue_amountデータを作成しない
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item1, amount: 30000)
      FactoryBot.create(:expense_revenue_item1, household: household, expense_revenue_item: expense_revenue_item2, amount: 5000)
      # (4)インスタンスメソッド「joins_data_expense_revenue_amount_and_item」でexpense_revenue_amountsテーブルとexpense_revenue_itemテーブルが内部結合された結果を
      # result_joins_data_expense_revenue_amount_and_item変数に格納し、結合されるべきデータとされないデータがそれぞれ含まれるかどうかを確認
      result_joins_data_expense_revenue_amount_and_item = household.joins_data_expense_revenue_amount_and_item(household)
      expect(result_joins_data_expense_revenue_amount_and_item.where(expense_revenue_item_id: expense_revenue_item1.id)).to be_present
      expect(result_joins_data_expense_revenue_amount_and_item.where(expense_revenue_item_id: expense_revenue_item2.id)).to be_present
      # ※expense_revenue_item3のみexpense_revenue_amountデータを作成していないので、結果に含まれないことを確認
      expect(result_joins_data_expense_revenue_amount_and_item.where(expense_revenue_item_id: expense_revenue_item3.id)).to be_blank
    end
  end

end
