require 'rails_helper'

RSpec.describe EducationExpense, type: :model do
  describe "バリデーション" do

    it "成功-すべての必須項目が入力されている場合、教育費の作成が有効であること" do
      education_expense = FactoryBot.build(:education_expense1)
      expect(education_expense).to be_valid
    end

    it "失敗-教育機関種別が入力されていない場合、教育費の作成が無効であること" do
      education_expense = FactoryBot.build(:education_expense1, education_institution_type: "")
      expect(education_expense).to be_invalid
    end

    it "失敗-運営母体が入力されていない場合、教育費の作成が無効であること" do
      education_expense = FactoryBot.build(:education_expense1, management_organization: "")
      expect(education_expense).to be_invalid
    end

    it "失敗-専攻が入力されていない場合、教育費の作成が無効であること" do
      education_expense = FactoryBot.build(:education_expense1, university_major: "")
      expect(education_expense).to be_invalid
    end

    it "失敗-年間費用が入力されていない場合、教育費の作成が無効であること" do
      education_expense = FactoryBot.build(:education_expense1, annual_expense: "")
      expect(education_expense).to be_invalid
    end

    it "失敗-下宿有無が入力されていない場合、教育費の作成が無効であること" do
      education_expense = FactoryBot.build(:education_expense1, boarding_house: "")
      expect(education_expense).to be_invalid
    end
  end

  describe "クラスメソッド" do
    it "引数で指定した検索条件と合致するデータがEducationExpenseから抽出できること" do
      # (1)検索対象のデータを作成
      search_education_expense = FactoryBot.build(:education_expense1)
      # (2)検索元のテーブル(=EducationExpenseテーブル)としてFactoryBotに定義した3つのデータを登録
      FactoryBot.create(:education_expense1)
      FactoryBot.create(:education_expense2)
      FactoryBot.create(:education_expense3)
      # (3)モデルに定義したクラスメソッドにて、検索対象データと合致するデータのidをEducationExpenseテーブルから抽出
      search_education_expense_id = EducationExpense.refer_education_expenses_master(
        search_education_expense.education_institution_type,
        search_education_expense.management_organization,
        search_education_expense.university_major,
        search_education_expense.boarding_house
      )
      # (4)3で抽出したidと合致するデータをEducationExpenseテーブルから抽出
      target_education_expense = EducationExpense.find(search_education_expense_id)
      # (5)4で抽出したデータと検索対象データが一致していることを確認(created_at、updated_at、idは照合対象外としたいのでそれぞれの変数ごとに値を照合)
      expect(search_education_expense.education_institution_type).to eq target_education_expense.education_institution_type
      expect(search_education_expense.management_organization).to eq target_education_expense.management_organization
      expect(search_education_expense.university_major).to eq target_education_expense.university_major
      expect(search_education_expense.boarding_house).to eq target_education_expense.boarding_house
    end
  end

end
