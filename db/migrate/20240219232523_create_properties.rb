class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.references  :household, null: false, foreign_key: true
      t.float       :best_annual_interest_rate
      t.float       :worst_annual_interest_rate
      t.integer     :car_properties_present_value
      t.integer     :housing_properties_present_value
      t.integer     :other_properties_present_value
      t.integer     :car_present_loan_balance
      t.integer     :housing_present_loan_balance
      t.integer     :other_present_loan_balance

      t.timestamps
    end
  end
end
