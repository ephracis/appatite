FactoryGirl.define do
  factory :application_setting, class: 'ApplicationSetting' do
    gitlab_url 'http://git.example.com/api/v3'
    gitlab_id 'my-gitlab-id'
    gitlab_secret 'my-gitlab-secret'
    github_id 'my-github-id'
    github_secret 'my-github-secret'
  end
end
