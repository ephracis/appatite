require 'rails_helper'

describe Admin::DashboardController, 'routing' do
  it 'to #index' do
    expect(get('/admin')).to route_to('admin/dashboard#index')
  end

  it 'to #users' do
    expect(get('/admin/users')).to route_to('admin/dashboard#users')
  end

  it 'to #projects' do
    expect(get('/admin/projects')).to route_to('admin/dashboard#projects')
  end
end

describe Admin::ApplicationSettingsController, 'routing' do
  it 'to #show' do
    expect(get('/admin/settings')).to route_to('admin/application_settings#show')
  end

  it 'to #update' do
    expect(patch('/admin/settings')).to route_to('admin/application_settings#update')
    expect(put('/admin/settings')).to route_to('admin/application_settings#update')
  end
end
