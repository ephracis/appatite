FactoryGirl.define do
  factory :commit, class: 'Commit' do
    message 'An example commit'
    sha 'd6cd1e2bd19e03a81132a23b2025920577f84e37'
    project
    user
  end
end
