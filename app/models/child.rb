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

  # -------インスタンスメソッドの定義-------
  # 資産状況の登録画面に表示するために、すでに登録されている子どもの教育機関ごとの教育方針情報（ChildEducationモデル）を取得する
  def get_child_education_data(education_institution_type,child)
    # 1.EducationExpenseとChilsEducationテーブルを内部結合
    joins_child_education_and_education_expense_list = EducationExpense.joins(:child_educations)
    # 2. 1で作成したデータセットのうち、引数で設定したeducation_institution_typeとchildの条件と一致するデータ（レコード）を抽出
    data_for_matching_child_and_education_institution_type = joins_child_education_and_education_expense_list.where( education_institution_type: education_institution_type, child_educations: {child_id: child})
    # 以下3点のデータを取得するために、2で作成したデータのうち必要なカラムを抽出する
    # (1)教育機関の運営母体が私立／公立か、(2)大学以降の教育機関が専門学校／4年生大学／6年生大学のいずれか、(3)子どもの大学の専攻が理系／文系のいずれで登録されているか
    return data_for_matching_child_and_education_institution_type.select("education_expenses.*").first
  end

end
