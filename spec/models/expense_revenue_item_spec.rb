require 'rails_helper'

RSpec.describe ExpenseRevenueItem, type: :model do
  describe "バリデーション" do
    it "成功-収支項目名が入力されてる場合、収支項目の作成が有効であること" do
      expense_revenue_item = FactoryBot.build(:expense_revenue_item)
      expect(expense_revenue_item).to be_valid
    end

    it "失敗-収支項目名が入力されていない場合、収支項目の作成が無効であること" do
      expense_revenue_item = FactoryBot.build(:expense_revenue_item, name: "")
      expect(expense_revenue_item).to be_invalid
    end
  end

end
