require 'rails_helper'

describe StaticController, 'routing' do
  it 'to #index' do
    expect(get('/')).to route_to('static#index')
  end

  it 'to #pricing' do
    expect(get('/pricing')).to route_to('static#pricing')
  end
end
