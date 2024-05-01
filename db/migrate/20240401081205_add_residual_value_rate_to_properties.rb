class AddResidualValueRateToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :car_annual_residual_value_rate, :float, default: 1.0
    add_column :properties, :housing_annual_residual_value_rate, :float, default: 1.0
    add_column :properties, :other_annual_residual_value_rate, :float, default: 1.0
  end
end
