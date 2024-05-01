class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      t.references :user, null: false, foreign_key: true
      t.integer    :birth_order
      t.integer    :age
      t.integer    :nursery_school_start_age

      t.timestamps
    end
  end
end
