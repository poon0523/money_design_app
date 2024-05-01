class CreateChildEducations < ActiveRecord::Migration[6.1]
  def change
    create_table :child_educations do |t|
      t.references :child, null: false, foreign_key: true
      t.references :education_expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
