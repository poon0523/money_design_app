class AddKindergartenStartAgeToChildren < ActiveRecord::Migration[6.1]
  def change
    add_column :children, :kindergarten_start_age, :integer
  end
end
