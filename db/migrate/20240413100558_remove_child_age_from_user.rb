class RemoveChildAgeFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :child1_age, :integer
    remove_column :users, :child2_age, :integer
    remove_column :users, :child3_age, :integer
  end
end
