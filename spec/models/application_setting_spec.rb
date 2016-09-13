require 'rails_helper'

describe ApplicationSetting, type: :model do
  let(:setting) { ApplicationSetting.create_from_defaults }

  describe '.create_from_defaults' do
    it { expect(setting).to be_valid }
  end

  describe 'validations' do
    let(:http)  { 'http://example.com' }
    let(:https) { 'https://example.com' }
    let(:ftp)   { 'ftp://example.com' }

    it 'should validate that :gitlab_url cannot be empty/falsy when :gitlab_enabled' do
      setting.gitlab_enabled = true
      expect(setting).to \
        validate_presence_of(:gitlab_url)
        .with_message("can't be blank when Gitlab authentication is enabled")
    end

    it { is_expected.to allow_value(http).for(:gitlab_url) }
    it { is_expected.to allow_value(https).for(:gitlab_url) }

    it 'should not allow :gitlab_url to be <"ftp://example.com">' do
      setting.gitlab_enabled = true
      expect(setting).to_not allow_value(ftp).for(:gitlab_url)
    end
  end

  describe '#setup_omniauth' do
    it 'should set up github strategy' do
      setting = create :application_setting
      strategy = OmniAuth::Strategies::GitHub.new('test')
      setting.setup_omniauth strategy
      expect(strategy.options[:client_id]).to eq(setting.github_id)
      expect(strategy.options[:client_secret]).to eq(setting.github_secret)
    end

    it 'should set up gitlab strategy' do
      setting = create :application_setting
      strategy = OmniAuth::Strategies::GitLab.new('test')
      setting.setup_omniauth strategy
      expect(strategy.options[:client_options][:site]).to eq(setting.gitlab_url)
      expect(strategy.options[:client_id]).to eq(setting.gitlab_id)
      expect(strategy.options[:client_secret]).to eq(setting.gitlab_secret)
    end

    it 'should raise exception on unsupported provider' do
      expect { setting.setup_omniauth(nil) }.to raise_error(RuntimeError)
    end
  end
end
