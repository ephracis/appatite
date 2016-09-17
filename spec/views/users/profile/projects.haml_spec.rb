require 'rails_helper'

describe 'users/profile/projects' do
  include Devise::Test::ControllerHelpers
  before do
    view.lookup_context.view_paths.push 'app/views/application'
    user = create(:user, name: 'Awesome User',
                         image: 'http://img.com/jpg',
                         website: 'http://foo.bar',
                         nickname: 'awesome-user',
                         location: 'testland')
    user.follow create(:project, user: user, name: 'Awesome Repo')
    assign :user, user
    render layout: 'layouts/profile', template: '/users/profile/projects'
  end

  it 'should display project name' do
    expect(rendered).to have_content 'Awesome Repo'
  end
end
