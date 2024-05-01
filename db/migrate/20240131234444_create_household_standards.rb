class CreateHouseholdStandards < ActiveRecord::Migration[6.1]
  def change
    create_table :household_standards do |t|
      t.boolean :marital_status,                             null:false, default:false
      t.integer :children_number,                            null:false, default:0
      t.references :expense_revenue_item, foreign_key: true, null:false
      t.float :expense_ratio_to_revenue,                     null:false, default:0

      t.timestamps
    end
  end
end
