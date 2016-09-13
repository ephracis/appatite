require 'rails_helper'

describe 'users/profile/show' do
  before do
    assign :user, create(:user, name: 'Awesome User', image: 'avatar-url')
    render
  end

  # it 'should display avatar' do
  #   expect(rendered).to have_selector 'img[src=avatar-url]'
  # end

  it 'should display name' do
    expect(rendered).to have_content 'Awesome User'
  end
end
