require 'rails_helper'

describe 'admin/dashboard/projects' do
  it 'should display temporary placeholder' do
    render
    expect(rendered).to match 'Project administration goes here'
  end

  # it 'should display notice when no project found' do
  #   render
  #   expect(rendered).to match 'No projects found'
  # end

  # it 'should display list of projects' do
  #   assign(:projects, [ create(:user, name: 'A Test Repo') ])
  #   render
  #   expect(rendered).to match 'A Test Repo'
  # end
end
