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
  end

  it 'should display user name' do
    render layout: 'layouts/profile', template: '/users/profile/show'
    expect(rendered).to have_content 'Awesome User'
  end

  it 'should state default location if missing' do
    assign :user, create(:user, location: '')
    render layout: 'layouts/profile', template: '/users/profile/show'
    expect(rendered).to have_content 'All over the place'
  end

  it 'should display avatar' do
    render layout: 'layouts/profile', template: '/users/profile/show'
    expect(rendered).to have_selector "img[src='http://img.com/jpg']"
  end

  it 'should display overview' do
    render layout: 'layouts/profile', template: '/users/profile/show'
    expect(rendered).to have_content 'Nice overview'
  end

  it 'should not display website when missing' do
    assign :user, create(:user, website: '')
    render layout: 'layouts/profile', template: '/users/profile/show'
    expect(rendered).to_not have_selector '.panel span.fa-link'
  end
end
