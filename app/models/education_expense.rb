class EducationExpense < ApplicationRecord
    # アソシエーションの設定
    has_many :child_educations, dependent: :destroy
    has_many :children, through: :child_educations, dependent: :destroy
    # バリデーションの設定
    validates :education_institution_type, presence: true
    validates :management_organization,    presence: true
    validates :university_major,           presence: true
    validates :annual_expense,             presence: true
    validates :boarding_house,             presence: true

    # enumの設定
    enum management_organization: { "公立": 1, "私立": 2 }
    enum university_major: { "理系": 1, "文系": 2 }
    enum education_institution_type:{ "保育園": 1, "幼稚園": 2, "小学校": 3, "中学校": 4, "高校": 5, "専門学校": 6, "4年生大学": 7, "6年生大学": 8 }
    enum boarding_house:{"下宿なし": 0, "下宿あり": 1 }

    # クラスメソッドの定義
    # Child_contorollerのsearch_education_expensesでのみ利用するメソッド
    # EducationExpenseマスタから引数に設定した条件と合致するidを抽出
    scope :refer_education_expenses_master, ->(education_institution_type,management_organization,university_major,boarding_house){
        if EducationExpense.find_by(
                education_institution_type: education_institution_type,
                management_organization:    management_organization,
                university_major:           university_major,
                boarding_house:             boarding_house
            ).present?
            EducationExpense.find_by(
                education_institution_type: education_institution_type,
                management_organization:    management_organization,
                university_major:           university_major,
                boarding_house:             boarding_house
            ).id
        else
            return ""
        end
    }
end
