FactoryBot.define do
  factory :user do
    name { "test_user" }
    email { "test_user@abc.com" }
    admin { true }
    age { 35 }
    marital_status { true }
    spouse_age { 33 }
    children_number { 2 }
    password { "test_user" }
    password_confirmation { "test_user" }
  end
  
end
