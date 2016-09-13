FactoryGirl.define do
  factory :account_link, class: 'AccountLink' do
    uid 'test'
    user
    trait :gitlab do
      provider 'gitlab'
    end
    trait :github do
      provider 'github'
    end
  end
end
