require 'rails_helper'

# <<補足>> describe/itに（★）が含まれているものは「データセットテスト」の対象とし、以下の通りテストを実施する
# (1)期待値となるデータセットをExcelで手動作成→csv変換して保存
# (2)spec/ficture/fileの配下に(1)を格納
# (3)it以下の処理内容の中で以下のように期待値となるデータセットをローカル変数（expected_テスト対象メソッド名）に読み込む
  # 例）test = file_fixture("Book10.csv").read.split(',').map(&:to_i)
# (4)テスト対象メソッドで出力したデータセットをローカル変数（actual_テスト対象メソッド名）に格納
# (5)eachメソッドを使って期待値となるデータセットとテスト対象メソッドから実際に出力したデータセットの値が等しいかをexpectメソッドで検証する

RSpec.describe Child, type: :model do
  describe "バリデーション" do
    it "成功-すべての必須項目が入力されている場合、子ども情報の作成が有効であること" do
      child = FactoryBot.build(:child)
      expect(child).to be_valid
    end

    it "失敗-何番目の子どもかが入力されていない場合、子ども情報の作成が無効であること" do
      child = FactoryBot.build(:child, birth_order: "")
      expect(child).to be_invalid
    end

    it "失敗-生年月日が入力されていない場合、子ども情報の作成が無効であること" do
      child = FactoryBot.build(:child, birth_year_month_day: "")
      expect(child).to be_invalid
    end

    it "失敗-保育園入学年齢が入力されていない場合、子ども情報の作成が無効であること" do
      child = FactoryBot.build(:child, nursery_school_start_age: "")
      expect(child).to be_invalid
    end

    it "失敗-幼稚園入学年齢が入力されていない場合、子ども情報の作成が無効であること" do
      child = FactoryBot.build(:child, kindergarten_start_age: "")
      expect(child).to be_invalid
    end
  end

  describe "クラスメソッド" do
    describe "子どもがいる場合にChildテーブルに子ども情報が登録されているかを確認するメソッド" do
      it "子どもがいる場合、Childテーブルに子どもの情報が登録されている場合はtrueを返すこと" do
        # (1)FactoryBotから子どもを持つユーザーのテストデータを作成
        user = FactoryBot.create(:user)
        # (2)1で作成したユーザーの1人目の子どもの情報をchildテーブルに登録
        child = FactoryBot.create(:child, user: user)
        # (3)クラスメソッドである「confirm_registration_of_child」にuserを引数として渡し、て子ども情報が保存されていることが確認できるか（＝trueを返すか）を確認
        result = Child.confirm_registration_of_child(user)
        expect(result).to eq true
      end

      it "子どもがいるにも関わらず、Childテーブルに子どもの情報が登録されていない場合はfalseを返すこと" do
        # (1)FactoryBotから子どもを持つユーザーのテストデータを作成
        user = FactoryBot.create(:user)
        # (2)クラスメソッドである「confirm_registration_of_child」にuserを引数として渡し、て子ども情報がまだ保存されていないことが確認できるか（＝falseを返すか）を確認
        result = Child.confirm_registration_of_child(user)
        expect(result).to eq false
      end
    end

    describe "ChildインスタンスとChildEducationインスタンスを作成するメソッド" do
      it "子どもがいる場合、子どもの人数分のChildインスタンスとそれぞれのchildインスタンスに対して6つのChildEducationインスタンスが生成されること" do
        # (1)FactoryBotから子どもを持つ（2人）ユーザーのテストデータを作成
        user = FactoryBot.create(:user)
        # (2)userの子どもの人数をローカル変数に格納
        user_children_num = user.children_number
        # (3)1で作成したuserを引数にクラスメソッド「create_child_and_children_education_instances」を実行し、その結果をローカル変数に格納
        # ※ローカル変数には子どもの人数分のインスタンスを要素とした配列が格納される
        children_instance_list = Child.create_child_and_children_education_instances(user)
        # (4)3で作成したリストの要素数（＝子どもの人数分のインスタンス）と2で定義したuserの子どもの数が一致するかを判定することでchildインスタンス作成を確認
        expect(user_children_num).to eq children_instance_list.length
        # (5)加えて、children_instance_listの各要素(childインスタンス)にchild_educationインスタンスが6つずつあるかを確認し、あればtrueをconfirm_num_of_child_education_insutances変数に格納
        confirm_num_of_child_education_insutances = children_instance_list.map {|child| 
          if child.child_educations.length == 6
            true
          else
            false
          end
        }
        # (6)confirm_num_of_child_education_insutances変数に格納された判定結果がすべてtrueであれば、各childインスタンスに対して6つのChildEducationインスタンスが生成できている
        expect(confirm_num_of_child_education_insutances.all? { |result| result == true }).to eq true

      end
    end

    describe "（★）今年の4月1日時点での子どもの満年齢を算出するメソッド" do
      it "子ども情報（child）が登録されている場合に、" do
        # (1)FactoryBotから子どもを持つユーザーのテストデータを作成
        user = FactoryBot.create(:user)
        # (2)1で作成したユーザーの子どもの生年月日を2023年2月5日としてchildテーブルに登録
        child = FactoryBot.create(:child, user: user)
        # (3)Excelで2024年4月時点での満年齢を計算した結果をローカル変数に格納
        expected_present_child_age = 1
        # (4)テスト対象のクラスメソッド「calc_age_of_child」を実行し、その結果をローカル変数に格納
        # 子どもの年齢算出のベース年月日の初期値を設定
        base_year_month_day = (Date.new(Date.today.year,04,01)).strftime("%Y%m%d").to_i
        actual_present_child_age = Child.calc_age_of_child(base_year_month_day,child.birth_year_month_day)
        # (5)3と4の値がすべて一致するかを確認
        expect(actual_present_child_age).to eq actual_present_child_age
      end
    end

    describe "（★）childテーブルとchild_educationテーブルの情報に対応した教育費を教育費マスタ（education_expense）から参照するメソッド" do
      it "子ども情報（child）と子どもの保育園～大学までの教育方針情報（child_education）が登録されている場合に、各年度の年間の教育費が参照されること" do
        # (1)FactoryBotから子ども（1人）を持つユーザーのテストデータを作成
        user = FactoryBot.create(:user, children_number: 1)
        # (2)1で作成したユーザーの子どもの情報をchildテーブルに登録
        child = FactoryBot.create(:child, user: user)
        # (3)2で作成した子どもの保育園~大学までの教育方針をchild_educationテーブルに登録
        # ※child_educationテーブルに登録するeducation_expense_idは事前にseedで導入した参照元テーブル（education_expensesマスタ）の値を設定する
        # a.保育園-公立
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(1))
        # b.幼稚園-公立
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(2))
        # c.小学校-私立
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(20))
        # d.中学校-私立
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(21))
        # e.高校-公立
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(5))
        # f.専門学校-理系-下宿無し
        FactoryBot.create(:child_education, child: child, education_expense: EducationExpense.find(9))
        # (4)Excelで作成した期待値となるデータセットをローカル変数に格納
        expected_create_education_expense_list = file_fixture("expected_education_expense_list.csv").read.split(',').map(&:to_i)
        # (5)テスト対象のクラスメソッド「create_education_expense_list」を実行し、その結果をローカル変数に格納
        actual_create_education_expense_list = Child.create_education_expense_list(child)
        # (6)4と5の値がすべて一致するかを確認
        actual_create_education_expense_list.each_with_index do |actual_education_expense, index|
          expect(actual_education_expense).to eq expected_create_education_expense_list[index]
        end
      end
    end

    describe "（★）子どもが複数名いる場合にすべての子どもの教育費を合算するメソッド" do
      it "すべての子ども情報（child）とそれらの保育園～大学までの教育方針情報（child_education）が登録されている場合に、各年度の年間の教育費がすべての子ども分合算されていること" do
        # (1)FactoryBotから子ども（2人）を持つユーザーのテストデータを作成
        user = FactoryBot.create(:user)
        # (2)1で作成したユーザーの子ども（2人分）の情報をchildテーブルに登録
        children = []
        child1 = FactoryBot.create(:child, user: user)
        child2 = FactoryBot.create(:child, user: user, birth_order: 2, birth_year_month_day: 20250205)
        children.push(child1,child2)
        
        # (3)2で作成した子ども（2人分）の保育園~大学までの教育方針をchild_educationテーブルに登録
        # ※child_educationテーブルに登録するeducation_expense_idは事前にseedで導入した参照元テーブル（education_expensesマスタ）の値を設定する
        # 1人目-a.保育園-公立
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(1))
        # 1人目-b.幼稚園-公立
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(2))
        # 1人目-c.小学校-私立
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(20))
        # 1人目-d.中学校-私立
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(21))
        # 1人目-e.高校-公立
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(5))
        # 1人目-f.専門学校-理系-下宿無し
        FactoryBot.create(:child_education, child: child1, education_expense: EducationExpense.find(9))

        # 2人目-a.保育園-公立
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(1))
        # 2人目-b.幼稚園-公立
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(2))
        # 2人目-c.小学校-私立
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(20))
        # 2人目-d.中学校-私立
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(21))
        # 2人目-e.高校-公立
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(5))
        # 2人目-f.専門学校-理系-下宿無し
        FactoryBot.create(:child_education, child: child2, education_expense: EducationExpense.find(9))
        
        # (4)Excelで作成した期待値となるデータセットをローカル変数に格納
        expected_total_education_expense_list = file_fixture("expected_total_education_expense_list.csv").read.split(',').map(&:to_i)
        # (5)テスト対象のクラスメソッド「create_total_education_expense_list」を実行し、その結果をローカル変数に格納
        actual_total_education_expense_list = Child.create_total_education_expense_list(children)
        
        # (6)4と5の値がすべて一致するかを確認
        actual_total_education_expense_list.each_with_index do |actual_total_education_expense, index|
          expect(actual_total_education_expense).to eq expected_total_education_expense_list[index]
        end
      end
    end


  end

  describe "インスタンスメソッド" do
    it "Childテーブルに登録されている子どもの教育機関ごとの教育方針情報（ChildEducationモデル）を取得するメソッド" do
      # (1)FactoryBotから子どもを持つユーザーのテストデータを作成
      user = FactoryBot.create(:user)
      # (2)1で作成したユーザーの1人目の子どもの情報をchildテーブルに登録
      child = FactoryBot.create(:child, user: user)
      # (3)教育費テーブルを参照するため、FactoryBotよりテストデータを作成
      # 公立-保育園のテストデータ登録
      education_expense1 = FactoryBot.create(:education_expense1)
      # 公立-幼稚園のテストデータ登録
      education_expense2 = FactoryBot.create(:education_expense2)
      # 私立-保育園のテストデータ登録
      FactoryBot.create(:education_expense1,management_organization: 2)
      # 私立-幼稚園のテストデータ登録
      FactoryBot.create(:education_expense2,management_organization: 2)
      # (4)2で登録した子どもの教育方針情報をchild_educationテーブルに登録。簡素化のために保育園、幼稚園のみを対象とする
      # 公立の保育園に通う方針としてchild_educationテーブルに登録
      FactoryBot.create(:child_education,child: child, education_expense: education_expense1)
      # 公立の幼稚園に通う方針としてchild_educationテーブルに登録
      FactoryBot.create(:child_education,child: child, education_expense: education_expense2)
      # ------>ここまでテストデータの作成

      # ------>ここからインスタンスメソッドの確認
      # (5)インスタンスメソッド「get_child_education_data」に引数を渡すことによって、childの保育園、幼稚園の教育方針情報が検索できるかを確認
      # a.保育園(education_institution_type=1)の教育方針を検索
      child_nursery_school = child.get_child_education_data(1,child)
      # b.幼稚園(education_institution_type=2)の教育方針を検索
      child_kindergarten = child.get_child_education_data(2,child)
      # (6)4にて保育園、幼稚園は公立に通う方針でchild_educationテーブルに登録しているので、5のaとbのmanagement_organizationの結果が「公立」となっていれば、インスタンスメソッド「get_child_education_data」が正しく情報を取得していることが確認できる
      expect(child_nursery_school.management_organization).to eq "公立"
      expect(child_kindergarten.management_organization).to eq "公立"   
    end
  end

end
