require 'rails_helper'

describe 'projects/setup' do
  before do
    assign :projects, [create(:project, name: 'foo/bar')]
    render
  end

  it 'should display project' do
    expect(rendered).to match 'foo/bar'
  end

  it 'should display activate button' do
    expect(rendered).to have_content 'Activate'
  end
end
