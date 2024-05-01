class ChildEducation < ApplicationRecord
  # アソシエーションの設定
  belongs_to :child
  belongs_to :education_expense
end
