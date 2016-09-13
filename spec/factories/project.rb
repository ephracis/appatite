FactoryGirl.define do
  factory :project, class: 'Project' do
    name 'test/project'
    user
    origin 'test'
    origin_id '123'
    api_url 'http://example.com'

    trait :github do
      origin 'github'
      api_url 'https://api.github.com/repos/test/project'
    end

    trait :gitlab do
      origin 'gitlab'
      api_url 'https://gitlab.com/api/v3/projects/123'
    end
  end
end
