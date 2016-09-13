require 'rails_helper.rb'

describe Admin::ApplicationSettingsController do
  render_views

  describe 'GET show' do
    it_behaves_like 'a restricted area', :get, :show
  end

  describe 'PATCH update' do
    let(:setting_params) do
      { application_setting: { gitlab_enabled: true, gitlab_url: 'http://x.io' } }
    end

    it 'should respond with success when no users exist' do
      patch :update, params: setting_params
      expect(response.status).to eq(302)
      expect(response).to redirect_to(admin_application_settings_path)
      expect(ApplicationSetting.current.gitlab_url).to \
        eq(setting_params[:application_setting][:gitlab_url])
    end

    it 'should respond with 404 when users exists but signed out' do
      create :user
      patch :update, params: setting_params
      expect(response.status).to eq(404)
    end

    it 'should respond with 404 when signed in as user' do
      user = create :user, is_admin: false
      sign_in user
      patch :update, params: setting_params
      expect(response.status).to eq(404)
    end

    it 'should respond with success when signed in as admin' do
      user = create :user, is_admin: true
      sign_in user
      patch :update, params: setting_params
      expect(response.status).to eq(302)
      expect(response).to redirect_to(admin_application_settings_path)
      expect(ApplicationSetting.current.gitlab_url).to \
        eq(setting_params[:application_setting][:gitlab_url])
    end
  end
end
