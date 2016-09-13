require 'rails_helper'

describe 'static/index' do
  before do
    render
  end

  it 'should display welcome message' do
    expect(rendered).to match 'Welcome to Appatite'
  end

  it 'should display screenshots' do
    expect(rendered).to match 'img-thumbnail'
  end
end
