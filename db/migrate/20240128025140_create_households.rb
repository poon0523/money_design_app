class CreateHouseholds < ActiveRecord::Migration[6.1]
  def change
    create_table :households do |t|
      t.references :user, foreign_key: true, null:false

      t.timestamps
    end
  end
end
