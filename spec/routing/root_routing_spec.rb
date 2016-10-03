require 'rails_helper'

describe RootController, 'routing' do
  it 'to #index' do
    expect(get('/')).to route_to('root#index')
  end

  it 'to #pricing' do
    expect(get('/pricing')).to route_to('root#pricing')
  end

  it 'to #crash' do
    expect(get('/crash')).to route_to('root#crash')
  end
end
