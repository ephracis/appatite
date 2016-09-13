require 'rails_helper'

describe 'projects/show' do
  before do
    assign :project, create(:project, name: 'foo/bar')
    render
  end

  it 'should display project name' do
    expect(rendered).to match 'foo/bar'
  end
end
