class CreateExpenseRevenueAmounts < ActiveRecord::Migration[6.1]
  def change
    create_table :expense_revenue_amounts do |t|
      t.references :expense_revenue_item, null: false, foreign_key: true
      t.references :household, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
