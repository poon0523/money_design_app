require 'rails_helper'

# <<補足>>ログイン機能はgem:deviseを利用しているため、組み込みのメソッドは検証せずに、自身で定義したバリデーションのみを検証

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "成功-すべての必須項目が入力されている場合、ユーザーの作成が有効であること" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it "失敗-配偶者が入力されていない場合、ユーザーの作成が無効であること" do
      user = FactoryBot.build(:user, marital_status: "")
      expect(user).to be_invalid
    end

    it "失敗-配偶者がいるにも関わらず、配偶者年齢が入力されていない場合、ユーザーの作成が無効であること" do
      user = FactoryBot.build(:user, marital_status: true, spouse_age: "")
      expect(user).to be_invalid
    end

  end
end
