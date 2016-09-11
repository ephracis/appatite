require 'rails_helper'

describe Users::OmniauthCallbacksController, 'routing' do
  it 'to #passthru' do
    expect(get('/users/auth/github')).to route_to('users/omniauth_callbacks#passthru')
    expect(get('/users/auth/gitlab')).to route_to('users/omniauth_callbacks#passthru')
  end

  it 'to #github' do
    expect(get('/users/auth/github/callback')).to route_to('users/omniauth_callbacks#github')
  end

  it 'to #gitlab' do
    expect(get('/users/auth/gitlab/callback')).to route_to('users/omniauth_callbacks#gitlab')
  end

  it 'to #setup' do
    expect(get('/users/auth/gitlab/setup')).to route_to('users/omniauth_callbacks#setup', provider: 'gitlab')
    expect(get('/users/auth/github/setup')).to route_to('users/omniauth_callbacks#setup', provider: 'github')
  end
end

describe Devise::SessionsController, 'routing' do
  it 'to #new' do
    expect(get('/login')).to route_to('devise/sessions#new')
  end

  it 'to #destroy' do
    expect(delete('/logout')).to route_to('devise/sessions#destroy')
  end
end

describe Users::ProfileController, 'routing' do
  it 'to #toggle_admin' do
    expect(patch('/users/1/toggle_admin')).to route_to('users/profile#toggle_admin', id: '1')
  end

  it 'to #show' do
    expect(get('/users/1')).to route_to('users/profile#show', id: '1')
  end

  it 'to #edit' do
    expect(get('/users/1/edit')).to route_to('users/profile#edit', id: '1')
  end

  it 'to #update' do
    expect(patch('/users/1')).to route_to('users/profile#update', id: '1')
  end
end
