FactoryBot.define do
  factory :property do
    best_annual_interest_rate { 0.07 }
    worst_annual_interest_rate { 0.03 }
    car_properties_present_value { 5000000 }
    housing_properties_present_value { 0 }
    other_properties_present_value { 1000000 }
    car_present_loan_balance { 4000000 }
    housing_present_loan_balance { 0 }
    other_present_loan_balance { 1000000 }
    car_annual_residual_value_rate { 0.8 }
    housing_annual_residual_value_rate { 0.7 }
    other_annual_residual_value_rate { 0.9 }
    car_loan_interest_rate { 0.015 }
    housing_loan_interest_rate { 0 }
    other_loan_interest_rate { 0.05 }

    household
    
  end
end
