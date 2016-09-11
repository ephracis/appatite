require 'rails_helper'

describe 'admin/application_settings/show' do
  before do
    assign(:application_setting, ApplicationSetting.current)
    render
  end

  it 'should display gitlab input' do
    expect(rendered).to have_selector 'input#application_setting_gitlab_url'
    expect(rendered).to have_selector 'input#application_setting_gitlab_id'
    expect(rendered).to have_selector 'input#application_setting_gitlab_secret'
  end

  it 'should display github input' do
    expect(rendered).to have_selector 'input#application_setting_github_id'
    expect(rendered).to have_selector 'input#application_setting_github_secret'
  end
end
