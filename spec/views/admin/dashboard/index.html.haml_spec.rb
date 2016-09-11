require 'rails_helper'

describe 'admin/dashboard/index' do
  it 'should display notice when no users found' do
    render
    expect(rendered).to match 'No users found'
  end

  it 'should display notice when no project found' do
    render
    expect(rendered).to match 'No projects found'
  end

  it 'should display list of recent users' do
    assign(:recent_users, [create(:user, name: 'A Test User')])
    render
    expect(rendered).to match 'A Test User'
  end

  it 'should display list of recent projects' do
    assign(:recent_projects, [create(:user, name: 'A Test Repo')])
    render
    expect(rendered).to match 'A Test Repo'
  end
end
