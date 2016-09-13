require 'rails_helper'

describe AuthHelper do
  describe 'auth_configured?' do
    it 'should return false when id is missing' do
      create :application_setting,
             github_id: nil, github_secret: 1,
             gitlab_id: nil, gitlab_secret: 1
      expect(helper.auth_configured?).to eq false
    end

    it 'should return false when secret is missing' do
      create :application_setting,
             github_id: 1, github_secret: nil,
             gitlab_id: 1, gitlab_secret: nil
      expect(helper.auth_configured?).to eq false
    end

    it 'should return true when github is configured' do
      create :application_setting,
             github_id: 1, github_secret: 1,
             gitlab_id: nil, gitlab_secret: nil
      expect(helper.auth_configured?).to eq true
    end

    it 'should return true when gitlab is configured' do
      create :application_setting,
             github_id: nil, github_secret: nil,
             gitlab_id: 1, gitlab_secret: 1
      expect(helper.auth_configured?).to eq true
    end
  end

  describe 'any_auth?' do
    it 'should return true when github is enabled' do
      create :application_setting, github_enabled: true, gitlab_enabled: false
      expect(helper.any_auth?).to eq true
    end

    it 'should return true when gitlab is enabled' do
      create :application_setting, github_enabled: false, gitlab_enabled: true
      expect(helper.any_auth?).to eq true
    end

    it 'should return false when nothing is enabled' do
      create :application_setting, github_enabled: false, gitlab_enabled: false
      expect(helper.any_auth?).to eq false
    end
  end

  describe 'github_auth?' do
    it 'should return false when github is disabled' do
      create :application_setting, github_enabled: false
      expect(helper.github_auth?).to eq false
    end

    it 'should return true when github is enabled' do
      create :application_setting, github_enabled: true
      expect(helper.github_auth?).to eq true
    end
  end

  describe 'gitlab_auth?' do
    it 'should return false when gitlab is disabled' do
      create :application_setting, gitlab_enabled: false
      expect(helper.gitlab_auth?).to eq false
    end

    it 'should return true when gitlab is enabled' do
      create :application_setting, gitlab_enabled: true
      expect(helper.gitlab_auth?).to eq true
    end
  end
end
