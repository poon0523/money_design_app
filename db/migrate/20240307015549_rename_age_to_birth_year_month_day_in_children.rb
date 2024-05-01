class RenameAgeToBirthYearMonthDayInChildren < ActiveRecord::Migration[6.1]
  def up
    rename_column :children, :age, :birth_year_month_day
  end

  def down
    rename_column :children, :birth_year_month_day, :age
  end
end
