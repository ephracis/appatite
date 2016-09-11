require 'rails_helper'

describe 'admin/dashboard/users' do
  it 'should display notice when no user found' do
    render
    expect(rendered).to match 'No users found'
  end

  it 'should display list of users' do
    assign(:projects, [create(:user, name: 'A Test User')])
    render
    expect(rendered).to match 'A Test User'
  end
end
