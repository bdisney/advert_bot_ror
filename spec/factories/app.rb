FactoryGirl.define do
  factory :app do
    name 'TestApp'
    url 'test-app.com'
    platform_id '42'
    block_types ['standard']
  end
end