class AddLoanInterestRateToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :car_loan_interest_rate, :float, default: 0.01
    add_column :properties, :housing_loan_interest_rate, :float, default: 0.01
    add_column :properties, :other_loan_interest_rate, :float, default: 0.01
  end
end
