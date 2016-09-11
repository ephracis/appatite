require 'rails_helper'

describe 'devise/sessions/new' do
  it 'should display notice when no auth configured' do
    render
    expect(rendered).to have_content 'You need to configure authentication with a provider'
  end

  it 'should display notice when no auth disabled' do
    create :application_setting, gitlab_enabled: false, github_enabled: false
    render
    expect(rendered).to have_content 'Authentication is disabled'
  end

  it 'should display gitlab button when enabled' do
    create :application_setting, gitlab_id: 'test', gitlab_secret: 'test', gitlab_enabled: true
    render
    expect(rendered).to have_content 'GitLab'
  end

  it 'should display github button when enabled' do
    create :application_setting, github_id: 'test', github_secret: 'test', github_enabled: true
    render
    expect(rendered).to have_content 'GitHub'
  end
end
