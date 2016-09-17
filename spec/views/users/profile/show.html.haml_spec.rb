require 'rails_helper'

describe 'users/profile/show' do
  include Devise::Test::ControllerHelpers
  before do
    view.lookup_context.view_paths.push 'app/views/application'
    assign :user, create(:user, name: 'Awesome User',
                                image: 'http://img.com/jpg',
                                website: 'http://foo.bar',
                                nickname: 'awesome-user',
                                location: 'testland')
    render layout: 'layouts/profile', template: '/users/profile/show'
  end

  it 'should display user name' do
    expect(rendered).to have_content 'Awesome User'
  end

  it 'should display avatar' do
    expect(rendered).to have_selector "img[src='http://img.com/jpg']"
  end

  it 'should display overview' do
    expect(rendered).to have_content 'Nice overview'
  end
end
