class RemoveAgeFromEducationExpense < ActiveRecord::Migration[6.1]
  def change
    remove_column :education_expenses, :age, :integer
  end
end
