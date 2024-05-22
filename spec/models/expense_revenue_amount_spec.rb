require 'rails_helper'

RSpec.describe ExpenseRevenueAmount, type: :model do
  describe "バリデーション" do
    it "成功-すべての必須項目に入力がある場合、ある家計における、ある収支項目の金額の作成が有効であること" do
      expense_revenue_amount = FactoryBot.build(:expense_revenue_item1)
      expect(expense_revenue_amount).to be_valid
    end

    it "失敗-金額の入力がない場合、ある家計における、ある収支項目の金額の作成が無効であること" do
      expense_revenue_amount = FactoryBot.build(:expense_revenue_item1, amount: "")
      expect(expense_revenue_amount).to be_invalid
    end
  end

end
