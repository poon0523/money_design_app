class CreateEducationExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :education_expenses do |t|
      t.integer :age,                        null:false, default:0
      t.integer :education_institution_type, null:false, default:0
      t.integer :management_organization,    null:false, default:0
      t.integer :university_major,           null:false, default:0
      t.integer :annual_expense,             null:false, default:0

      t.timestamps
    end
  end
end
