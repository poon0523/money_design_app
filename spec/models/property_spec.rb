require 'rails_helper'

# <<補足>> describe/itに（★）が含まれているものは「データセットテスト」の対象とし、以下の通りテストを実施する
# (1)期待値となるデータセットをExcelで手動作成→csv変換して保存
# (2)spec/ficture/fileの配下に(1)を格納
# (3)it以下の処理内容の中で以下のように期待値となるデータセットをローカル変数（expected_テスト対象メソッド名）に読み込む
  # 例）test = file_fixture("Book10.csv").read.split(',').map(&:to_i)
# (4)テスト対象メソッドで出力したデータセットをローカル変数（actual_テスト対象メソッド名）に格納
# (5)eachメソッドを使って期待値となるデータセットとテスト対象メソッドから実際に出力したデータセットの値が等しいかをexpectメソッドで検証する


RSpec.describe Property, type: :model do
  describe "バリデーション" do
    it "成功-すべての必須項目が入力されている場合、資産情報の作成が有効であること" do
      property = FactoryBot.build(:property)
      expect(property).to be_valid
    end

    it "失敗-投資年利率（ベスト）が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, best_annual_interest_rate: "")
      expect(property).to be_invalid
    end

    it "失敗-投資年利率（ワースト）が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, worst_annual_interest_rate: "")
      expect(property).to be_invalid
    end

    it "失敗-車の現在価値が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, car_properties_present_value: "")
      expect(property).to be_invalid
    end

    it "失敗-住宅の現在価値が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, housing_properties_present_value: "")
      expect(property).to be_invalid
    end

    it "失敗-その他の現在価値が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, other_properties_present_value: "")
      expect(property).to be_invalid
    end


    it "失敗-車の現在ローン残高が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, car_present_loan_balance: "")
      expect(property).to be_invalid
    end

    it "失敗-住宅の現在ローン残高が入力されていない場合、資産情報の作成が無効であること" do
      property = FactoryBot.build(:property, housing_present_loan_balance: "")
      expect(property).to be_invalid
    end
  end

  describe "クラスメソッド" do
    it "ユーザーが持つ家計状況の情報に紐づく資産状況情報の登録がある場合、資産状況情報のidを取得するメソッド" do
      user = FactoryBot.create(:user)
      users_household = FactoryBot.create(:household, user: user)
      property = FactoryBot.create(:property, household: users_household)
      result_get_property_id = Property.get_property_id(user)
      expect(result_get_property_id.id).to eq property.id
    end

    it "資産状況を観察する年数を設定するメソッド" do
      # 資産状況を観察する年数=60年なので、クラスメソッド「set_years_of_observation」が60と等しいことを確認
      expect(Property.set_years_of_observation).to eq 60
    end

    it "（★）資産状況テーブル表示用として60年間のうち、5年置きに年度を抽出して格納するためのメソッド" do
      # (1)Excelで今年(2024年)から60年間の年度のデータセットを作成の上、5年置きに年度を抽出したデータセットをローカル変数に格納
      expected_years_list_every_5years = file_fixture("expecte_years_list_every_5years.csv").read.split(',').map(&:to_i)
      # (2)テスト対象のクラスメソッド「create_years_list_every_5years」を実行し、その結果をローカル変数に格納
      actual_years_list_every_5years = Property.create_years_list_every_5years
      # (3)1と2の値がすべて一致するかを確認
      actual_years_list_every_5years.each_with_index do |actual_years_list_every_5years, index|
        expect(actual_years_list_every_5years).to eq expected_years_list_every_5years[index]
      end
    end

    it "（★）状況を示す各種データ（60年分）から5年おきにデータを抽出してリストを作成するためのメソッド" do
    end
  end

  describe "インスタンスメソッド" do
    let!(:user) { create(:user, children_number: 1) }
    let!(:users_child) { create(:child, user: user) }
    let!(:users_child_education1) { create(:child_education, child: users_child, education_expense: EducationExpense.find(1)) }
    let!(:users_child_education2) { create(:child_education, child: users_child, education_expense: EducationExpense.find(2)) }
    let!(:users_child_education3) { create(:child_education, child: users_child, education_expense: EducationExpense.find(20)) }
    let!(:users_child_education4) { create(:child_education, child: users_child, education_expense: EducationExpense.find(21)) }
    let!(:users_child_education5) { create(:child_education, child: users_child, education_expense: EducationExpense.find(5)) }
    let!(:users_child_education6) { create(:child_education, child: users_child, education_expense: EducationExpense.find(9)) }
    let!(:users_household) { create(:household, user: user) }
    let!(:property) { create(:property, household: users_household) }
    ExpenseRevenueItem.all.each do |item|
      let!(:"expense_revenue_item#{item.id}") { create(:"expense_revenue_item#{item.id}", household: users_household) }
    end


    it "（★）現金・貯蓄金額60年分のデータを作成するメソッド" do
      # ユーザーに紐づく子ども（1人）のリストを作成
      children = []
      children.push(users_child)

      # (1)Excelで作成した期待値となるデータセットをローカル変数に格納
      expected_cash_and_saving_list = file_fixture("expected_cash_and_saving_list.csv").read.split(',').map(&:to_i)

      # (2)テスト対象のクラスメソッド「cash_and_saving_list」を実行し、その結果をローカル変数に格納
      monthly_revenue_expenditure = users_household.joins_data_expense_revenue_amount_and_item(users_household)
      actual_cash_and_saving_list = property.create_cash_and_saving_list(monthly_revenue_expenditure,children)

      # (3)1と2の値がすべて一致するかを確認
      actual_cash_and_saving_list.each_with_index do |actual_cash_and_saving, index|
        expect(actual_cash_and_saving).to eq expected_cash_and_saving_list[index]
      end
    end

    it "投資資産額60年分のデータを作成するメソッド-投資利率が好調の場合を想定（=best_annual_interest_rate)" do
      expected_best_investment_property_list = file_fixture("expected_best_investment_property_list.csv").read.split(',').map(&:to_i)
      actual_best_investment_property_list = property.create_investment_list(users_household.get_specific_expense_revenue_amount(users_household,"積立投資額"),property.best_annual_interest_rate.truncate(2))
      actual_best_investment_property_list.each_with_index do |best_investment_property, index|
        expect(best_investment_property.round).to eq expected_best_investment_property_list[index]
      end          
    end

    it "使用資産60年分のデータを作成するメソッド-使用資産は「車」を想定" do
      expected_car_property_list = file_fixture("expected_car_property_list.csv").read.split(',').map(&:to_i)
      actual_car_property_list = property.create_used_properties_list(property.car_properties_present_value,property.car_annual_residual_value_rate)
      actual_car_property_list.each_with_index do |actual_car_property, index|
        expect(actual_car_property.round).to eq expected_car_property_list[index]
      end          
    end

    it "ローン60年分のデータを作成するメソッド-使用資産は「車」を想定" do
      expected_car_loan_list = file_fixture("expected_car_loan_list.csv").read.split(',').map(&:to_i)
      actual_car_loan_list = property.create_loan_list(property.car_present_loan_balance, users_household.get_specific_expense_revenue_amount(users_household,"ローン返済額（車）"), property.car_loan_interest_rate)
      actual_car_loan_list.each_with_index do |actual_car_loan, index|
        expect(actual_car_loan.round).to eq expected_car_loan_list[index]
      end          
    end

    it "（臨時収入／臨時支出がなし）総資産60年分のデータを作成するメソッド-投資利率が好調の場合を想定" do
      children = []
      children.push(users_child)
      expected_total_property_list = file_fixture("expected_total_property_list.csv").read.split(',').map(&:to_i)
      actual_total_property_list = property.create_total_property_list(property,users_household,children,property.best_annual_interest_rate)
      actual_total_property_list.each_with_index do |actual_total_property, index|
        expect(actual_total_property.round).to eq expected_total_property_list[index]
      end          
    end

    it "（臨時収入／臨時支出があり）総資産60年分のデータを作成するメソッド-投資利率が好調の場合を想定" do
      children = []
      children.push(users_child)
      expected_adjust_total_property_list = file_fixture("expected_adjust_total_property_list.csv").read.split(',').map(&:to_i)
      adjusted_cash_and_saving = file_fixture("expected_adjusted_cash_and_saving_list.csv").read.split(',').map(&:to_i)
      actual_adjust_total_property_list = property.create_total_property_list(property,users_household,children,property.best_annual_interest_rate,adjusted_cash_and_saving)
      actual_adjust_total_property_list.each_with_index do |actual_adjust_total_property, index|
        expect(actual_adjust_total_property.round).to eq expected_adjust_total_property_list[index]
      end          
    end

    it "総負債60年分のデータを作成するメソッド-投資利率が好調の場合を想定" do
      children = []
      children.push(users_child)
      expected_total_liability_list = file_fixture("expected_total_liability_list.csv").read.split(',').map(&:to_i)
      actual_total_liability_list = property.create_total_liability_list(property,users_household,children)
      actual_total_liability_list.each_with_index do |actual_total_liability, index|
        expect(actual_total_liability.round).to eq expected_total_liability_list[index]
      end          
    end

    it "純資産60年分のデータを作成するメソッド-投資利率が好調の場合を想定" do
      children = []
      children.push(users_child)
      expected_net_property_list = file_fixture("expected_net_property_list.csv").read.split(',').map(&:to_i)
      actual_net_property_list = property.create_net_property_list(property,users_household,children,property.best_annual_interest_rate.truncate(2))
      actual_net_property_list.each_with_index do |actual_net_property, index|
        expect(actual_net_property.round).to eq expected_net_property_list[index]
      end          
    end

    it "臨時収入・支出入力時の現金・貯蓄金額60年分のデータを作成するメソッド-投資利率が好調の場合を想定" do
      children = []
      children.push(users_child)
      monthly_revenue_expenditure = users_household.joins_data_expense_revenue_amount_and_item(users_household)
      adjust_revenue_list = file_fixture("test_adjust_revenue_list.csv").read.split(',').map(&:to_i)
      adjust_expenditure_list  = file_fixture("test_adjust_expenditure_list.csv").read.split(',').map(&:to_i) 
      expected_adjusted_cash_and_saving_list = file_fixture("expected_adjusted_cash_and_saving_list.csv").read.split(',').map(&:to_i)
      actual_adjusted_cash_and_saving_list = property.create_cash_and_saving_list(monthly_revenue_expenditure,children,adjust_revenue_list,adjust_expenditure_list)
      actual_adjusted_cash_and_saving_list.each_with_index do |adjusted_cash_and_saving, index|
        expect(adjusted_cash_and_saving.round).to eq expected_adjusted_cash_and_saving_list[index]
      end          
    end

  end

end
