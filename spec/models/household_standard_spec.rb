require 'rails_helper'

RSpec.describe HouseholdStandard, type: :model do
  describe "バリデーション" do
    it "成功-すべての必須項目が入力されている場合場合、家計基準の作成が有効であること" do
      household_standard = FactoryBot.build(:household_standard)
      expect(household_standard).to be_valid
    end

    it "失敗-配偶者有無が入力されていない場合、家計基準の作成が無効であること" do
      household_standard = FactoryBot.build(:household_standard, marital_status: "")
      expect(household_standard).to be_invalid
    end

    it "失敗-子どもの数が入力されていない場合、家計基準の作成が無効であること" do
      household_standard = FactoryBot.build(:household_standard, children_number: "")
      expect(household_standard).to be_invalid
    end

    it "失敗-収支比率が入力されていない場合、家計基準の作成が無効であること" do
      household_standard = FactoryBot.build(:household_standard, expense_ratio_to_revenue: "")
      expect(household_standard).to be_invalid
    end

  end
end
