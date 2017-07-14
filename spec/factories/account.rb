FactoryGirl.define do
  sequence :email do |n|
    "test_#{n}@test.com"
  end

  factory :account do
    email
    password '123456'
  end
end