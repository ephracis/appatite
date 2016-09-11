require 'rails_helper'

describe 'static/pricing' do
  before do
    render
  end

  it 'should display free tier' do
    expect(rendered).to match 'Open Source'
    expect(rendered).to match 'Free'
  end

  it 'should display standard tier' do
    expect(rendered).to match 'Standard'
    expect(rendered).to match '1/mo'
  end

  it 'should display premium tier' do
    expect(rendered).to match 'Premium'
    expect(rendered).to match '9/mo'
  end
end
