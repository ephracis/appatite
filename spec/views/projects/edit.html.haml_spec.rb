require 'rails_helper'

describe 'projects/edit' do
  before do
    assign :project, create(:project)
    render
  end

  it 'should display save button' do
    expect(rendered).to have_selector "input[value='Update Project']"
  end
end
