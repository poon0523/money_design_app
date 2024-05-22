require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "バリデーション" do

    it "成功-カテゴリ名が入力されている場合、カテゴリの作成が有効であること" do
      category = FactoryBot.build(:category)
      expect(category).to be_valid
    end

    it "失敗-カテゴリ名が入力されていない場合、カテゴリの作成が無効であること" do
      category = FactoryBot.build(:category, category: "")
      expect(category).to be_invalid
    end

  end

end
