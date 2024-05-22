EducationExpense.seed(
    # <公立>--------------------------------
    { id: 1, education_institution_type: 1, management_organization: 1, university_major: 0, annual_expense: 20000, boarding_house: 0},
    { id: 2, education_institution_type: 2, management_organization: 1, university_major: 0, annual_expense: 10000, boarding_house: 0},    
    { id: 3, education_institution_type: 3, management_organization: 1, university_major: 0, annual_expense: 3000, boarding_house: 0},
    { id: 4, education_institution_type: 4, management_organization: 1, university_major: 0, annual_expense: 4000, boarding_house: 0},
    { id: 5, education_institution_type: 5, management_organization: 1, university_major: 0, annual_expense: 5000, boarding_house: 0},
    # 理系（下宿あり）
    { id: 6, education_institution_type: 6, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 1},
    { id: 7, education_institution_type: 7, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 1},
    { id: 8, education_institution_type: 8, management_organization: 1, university_major: 1, annual_expense: 100000, boarding_house: 1},
    # 理系（下宿無し）
    { id: 9, education_institution_type: 6, management_organization: 1, university_major: 1, annual_expense: 30000, boarding_house: 0},
    { id: 10, education_institution_type: 7, management_organization: 1, university_major: 1, annual_expense: 30000, boarding_house: 0},
    { id: 11, education_institution_type: 8, management_organization: 1, university_major: 1, annual_expense: 80000, boarding_house: 0},
    # 文系（下宿あり）
    { id: 12, education_institution_type: 6, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { id: 13, education_institution_type: 7, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { id: 14, education_institution_type: 8, management_organization: 1, university_major: 2, annual_expense: 100000, boarding_house: 1},
    # 文系（下宿無し）
    { id: 15, education_institution_type: 6, management_organization: 1, university_major: 2, annual_expense: 30000, boarding_house: 0},
    { id: 16, education_institution_type: 7, management_organization: 1, university_major: 2, annual_expense: 30000, boarding_house: 0},
    { id: 17, education_institution_type: 8, management_organization: 1, university_major: 2, annual_expense: 80000, boarding_house: 0},

    # <私立>--------------------------------
    { id: 18, education_institution_type: 1, management_organization: 2, university_major: 0, annual_expense: 60000, boarding_house: 0},
    { id: 19, education_institution_type: 2, management_organization: 2, university_major: 0, annual_expense: 30000, boarding_house: 0},    
    { id: 20, education_institution_type: 3, management_organization: 2, university_major: 0, annual_expense: 30000, boarding_house: 0},
    { id: 21, education_institution_type: 4, management_organization: 2, university_major: 0, annual_expense: 40000, boarding_house: 0},
    { id: 22, education_institution_type: 5, management_organization: 2, university_major: 0, annual_expense: 50000, boarding_house: 0},
    # 理系（下宿あり）
    { id: 23, education_institution_type: 6, management_organization: 2, university_major: 1, annual_expense: 130000, boarding_house: 1},
    { id: 24, education_institution_type: 7, management_organization: 2, university_major: 1, annual_expense: 150000, boarding_house: 1},
    { id: 25, education_institution_type: 8, management_organization: 2, university_major: 1, annual_expense: 170000, boarding_house: 1},
    # 理系（下宿無し）
    { id: 26, education_institution_type: 6, management_organization: 2, university_major: 1, annual_expense: 80000, boarding_house: 0},
    { id: 27, education_institution_type: 7, management_organization: 2, university_major: 1, annual_expense: 100000, boarding_house: 0},
    { id: 28, education_institution_type: 8, management_organization: 2, university_major: 1, annual_expense: 120000, boarding_house: 0},
    # 文系（下宿あり）
    { id: 29, education_institution_type: 6, management_organization: 2, university_major: 2, annual_expense: 110000, boarding_house: 1},
    { id: 30, education_institution_type: 7, management_organization: 2, university_major: 2, annual_expense: 130000, boarding_house: 1},
    { id: 31, education_institution_type: 8, management_organization: 2, university_major: 2, annual_expense: 150000, boarding_house: 1},
    # 文系（下宿なし）
    { id: 32, education_institution_type: 6, management_organization: 2, university_major: 2, annual_expense: 60000, boarding_house: 1},
    { id: 33, education_institution_type: 7, management_organization: 2, university_major: 2, annual_expense: 80000, boarding_house: 1},
    { id: 34, education_institution_type: 8, management_organization: 2, university_major: 2, annual_expense: 100000, boarding_house: 1}
)
