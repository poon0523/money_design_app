FactoryBot.define do
  # クラスメソッドのテストを行うため複数のテストデータを作成
  factory :education_expense1, class: EducationExpense do
    education_institution_type { 1 }
    management_organization { 1 }
    university_major { 0 }
    annual_expense { 20000 }
    boarding_house { 0 }
  end

  factory :education_expense2, class: EducationExpense do
    education_institution_type { 2 }
    management_organization { 1 }
    university_major { 0 }
    annual_expense { 10000 }
    boarding_house { 0 }
  end

  factory :education_expense3, class: EducationExpense do
    education_institution_type { 3 }
    management_organization { 1 }
    university_major { 0 }
    annual_expense { 3000 }
    boarding_house { 0 }
  end

end
