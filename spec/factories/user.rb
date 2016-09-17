FactoryGirl.define do
  factory :user, class: 'User' do
    name 'Alice'
    sequence(:email) { |n| "user_#{n}@mail.com" }
    sequence(:nickname) { |n| "user_#{n}" }
  end
end
