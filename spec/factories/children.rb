FactoryBot.define do
  factory :child do
    birth_order { 1 }
    birth_year_month_day { 20230205 }
    nursery_school_start_age { 1 }
    kindergarten_start_age { 4 }

    user

  end
end
