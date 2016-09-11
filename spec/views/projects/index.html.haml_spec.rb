require 'rails_helper'

describe 'projects/index' do
  before do
    assign :projects, [create(:project, name: 'foo/bar')]
    render
  end

  it 'should display project' do
    expect(rendered).to match 'foo/bar'
  end
end
