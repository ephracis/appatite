require 'rails_helper'

describe 'users/profile/edit' do
  before do
    assign :user, create(:user, name: 'Awesome User')
    render
  end

  it 'should display avatar input' do
    expect(rendered).to have_selector 'input#user_image'
  end

  it 'should display name input' do
    expect(rendered).to have_selector 'input#user_name'
  end

  it 'should display email input' do
    expect(rendered).to have_selector 'input#user_email'
  end
end
