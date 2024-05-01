class AddTitleColumnToHouseholds < ActiveRecord::Migration[6.1]
  def change
    add_column :households, :title, :string, null:false, default:"YYYYMMDD家計状況(Ver.0)"
  end
end
