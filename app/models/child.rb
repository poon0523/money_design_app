class Child < ApplicationRecord
  # バリデーションの設定
  validates :birth_order,              presence: true
  validates :birth_year_month_day,     presence: true
  validates :nursery_school_start_age, presence: true
  validates :kindergarten_start_age,   presence: true

  # アソシエーションの設定
  belongs_to :user
  has_many :child_educations, dependent: :destroy
  has_many :education_expenses, through: :child_educations, dependent: :destroy
  accepts_nested_attributes_for :child_educations, allow_destroy: true

  # -------クラスメソッドの定義-------
  # 子どもがいる場合にChildテーブルに子ども情報が登録されているかを確認する
  def self.confirm_registration_of_child(current_user)
    if current_user.children_number > 0 && current_user.children.present?
      return true
    elsif current_user.children_number > 0 && current_user.children.nil?
      return  false
    else
      return false
    end
  end

  # Childインスタンス作成とChildEducationインスタンスの作成をする
  def self.create_child_and_children_education_instances(current_user)
    # 子どもの人数分のインスタンスを作成して配列として格納
    children_list = []
    # ユーザーの子どもの人数を取得
    children_num = current_user.children_number
    birth_order = 1
    # 子どもの人数分のChildインスタンスを生成し、@childrenインスタンスに１人分ずつ追加
    children_num.times do
      child = current_user.children.new(birth_order: birth_order)
      birth_order += 1
    # 子どもの教育費は保育園~大学まで全6種類の教育方針の情報を個別に登録する必要があるため、6つのchild_educationsインスタンスを生成
      6.times do
        child.child_educations.build
      end
      children_list.push(child)
    end 

    return children_list

  end


  # 子どもの教育方針に応じて教育費マスタから教育費を参照し、保育園~大学までの教育費のデータ作成
  # 注：子どもが複数人いる場合、1人ずつに対して本処理が行われる。すべての子どもの教育費の合算はprivateメソッドである、create_total_education_expense_listにて行われる
  def self.create_education_expense_list(child)
    # 子どもの年齢算出のベース年月日の初期値を設定
    base_year_month_day = (Date.new(Date.today.year,04,01)).strftime("%Y%m%d").to_i
    # 毎年の年間教育費を格納するための変数の初期値設定
    annual_education_expense = 0
    # 資産状況観察対象期間の各年の年間教育費を配列として格納するための変数の初期値設定
    education_expenses_list = []
    # 各子どもの教育段階に応じ再た教育費を教育費マスタ（education_expenses）から抽出し配列として変数に定義
    education_expenses_of_every_education_institution_type = 
        EducationExpense.joins(:child_educations).select("education_expenses.*, child_educations.child_id").where( child_educations:{child_id: child.id} )
    # 資産状況観測対象期間分の教育費用をeducation_expenses_of_every_education_institution_typeから参照し、education_expenses_listに順番に追加
    # education_expenses_of_every_education_institution_typeのうち、どの値を参照するかは子どもの年齢により判断する
    Property::YEARS_OF_OBSERVATION.times do
        # privateメソッドであるcalc_age_of_childメソッドより各年時点での子どもの年齢を算出
        age = Child.calc_age_of_child(base_year_month_day,child.birth_year_month_day)

        # 出生前の場合
        if age < 0 then
            annual_education_expense = 0
        # 3才未満の場合
        elsif age < 3 && age >= child.nursery_school_start_age then
            annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
        # 3才以上、6才未満の場合
        elsif 3 <= age  &&  age < 6
            # 幼稚園には行かずに、保育園に行く場合
            if child.kindergarten_start_age > age && child.nursery_school_start_age < child.kindergarten_start_age
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
            # 幼稚園には行かずに、保育園を継続する場合
            elsif child.kindergarten_start_age == child.nursery_school_start_age
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
            # 幼稚園に行く場合
            elsif age >= child.kindergarten_start_age
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 2).annual_expense
            end
        # 6才以上、13歳未満の場合
        elsif 6 <= age && age < 13 then
            annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 3).annual_expense
        # 13歳以上、16歳未満の場合
        elsif 13 <= age && age < 16 then
            annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 4).annual_expense
        # 16歳以上、19歳未満の場合
        elsif  16 <= age && age < 19 then
            annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 5).annual_expense
        # 19歳以上の場合
        elsif  19 <= age then
            # 専門学校で21歳未満の場合
            if education_expenses_of_every_education_institution_type.find_by(education_institution_type: 6).present? && age < 21 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 6).annual_expense
            # 4年生大学で23歳未満の場合
            elsif education_expenses_of_every_education_institution_type.find_by(education_institution_type: 7).present? && age < 23 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 7).annual_expense
            # 6年生大学で25歳未満の場合
            elsif education_expenses_of_every_education_institution_type.find_by(education_institution_type: 8).present? && age < 25 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 8).annual_expense
            else
                annual_education_expense = 0
            end
        end

        # if文で設定したannual_education_expenseをeducation_expenses_listに追加
        education_expenses_list.push(annual_education_expense)
        # base_year_month_dayを翌年に進める
        base_year_month_day += 10000
    end

    return education_expenses_list

  end

  # （子どもが複数人いる場合を考慮して）子どもの総教育費算出
  def self.create_total_education_expense_list(children)
    total_education_expenses_list = []
    children.each do |child|
        education_expense_list = Child.create_education_expense_list(child)
        total_education_expenses_list.push(education_expense_list)
    end

    return total_education_expenses_list.transpose.map{ |annual_total_education_expenses| annual_total_education_expenses.inject(:+) }
  end

  def self.calc_age_of_child(base_year_month_day,birth_year_month_day)
    return (base_year_month_day - birth_year_month_day)/10000
  end

  # -------インスタンスメソッドの定義-------
  # 資産状況の登録画面に表示するために、すでにChildテーブルに登録されている子どもの教育機関ごとの教育方針情報（ChildEducationモデル）を取得する
  def get_child_education_data(education_institution_type,child)
    # 1.EducationExpenseとChilsEducationテーブルを内部結合
    joins_child_education_and_education_expense_list = EducationExpense.joins(:child_educations)
    # 2. 1で作成したデータセットのうち、引数で設定したeducation_institution_typeとchildの条件と一致するデータ（レコード）を抽出
    data_for_matching_child_and_education_institution_type = joins_child_education_and_education_expense_list.where( education_institution_type: education_institution_type, child_educations: {child_id: child})
    # 3.以下3点のデータを取得するために、2で作成したデータのうち必要なカラムを抽出する
    # (1)教育機関の運営母体が私立／公立か、(2)大学以降の教育機関が専門学校／4年生大学／6年生大学のいずれか、(3)子どもの大学の専攻が理系／文系のいずれで登録されているか
    return data_for_matching_child_and_education_institution_type.select("education_expenses.*").first
  end

end
