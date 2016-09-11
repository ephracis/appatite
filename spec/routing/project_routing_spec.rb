require 'rails_helper'

describe ProjectsController, 'routing' do
  it 'to #setup' do
    expect(get('/projects/setup')).to route_to('projects#setup')
  end

  it 'to #webhook' do
    expect(post('/projects/webhook')).to route_to('projects#webhook')
  end

  it 'to #index' do
    expect(get('/projects')).to route_to('projects#index')
  end

  it 'to #create' do
    expect(post('/projects')).to route_to('projects#create')
  end

  it 'to #edit' do
    expect(get('/projects/1/edit')).to route_to('projects#edit', id: '1')
  end

  it 'to #show' do
    expect(get('/projects/1')).to route_to('projects#show', id: '1')
  end

  it 'to #update' do
    expect(put('/projects/1')).to route_to('projects#update', id: '1')
    expect(patch('/projects/1')).to route_to('projects#update', id: '1')
  end

  it 'to #destroy' do
    expect(delete('/projects/1')).to route_to('projects#destroy', id: '1')
  end
end
