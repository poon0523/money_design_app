class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string, default: "", null: false
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :age, :integer, default: 20, null: false
    add_column :users, :marital_status, :boolean, default: false, null: false
    add_column :users, :spouse_age, :integer
    add_column :users, :children_number, :integer, default: 0, null: false
    add_column :users, :child1_age, :integer
    add_column :users, :child2_age, :integer
    add_column :users, :child3_age, :integer
  end
end
