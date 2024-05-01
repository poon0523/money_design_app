class AddBoardingHouseToEducationExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :education_expenses, :boarding_house, :integer, null:false, default:0
  end
end
