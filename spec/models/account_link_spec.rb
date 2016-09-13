require 'rails_helper'

describe AccountLink, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe '.from_omniauth' do
    let(:auth_obj) do
      JSON.parse({
        uid: 'test',
        provider: 'gitlab',
        info: {
          email: 'test@mail.com',
          name: 'Mr Test',
          image: 'test.jpg'
        },
        credentials: {
          token: 'secret'
        }
      }.to_json, object_class: OpenStruct)
    end

    it 'should create user and link' do
      link = AccountLink.from_omniauth(auth_obj)
      expect(link).to be_valid
      expect(link.uid).to eq 'test'
      expect(link.user.name).to eq 'Mr Test'
      expect(link.user.email).to eq 'test@mail.com'
    end

    it 'should find link if already existing' do
      create :account_link, :gitlab
      expect do
        AccountLink.from_omniauth(auth_obj)
      end.not_to change { AccountLink.count }
    end

    it 'should find user if already existing' do
      create :user, email: 'test@mail.com'
      expect do
        AccountLink.from_omniauth(auth_obj)
      end.not_to change { User.count }
    end
  end

  describe '#backend' do
    it 'should cache backend object between calls' do
      link = create :account_link, :gitlab
      expect(link).to receive(:load_backend).once.and_return 1
      link.backend
      link.backend
    end

    it 'should create gitlab backend' do
      setting = create :application_setting
      allow(ApplicationSetting).to receive(:current).and_return setting
      link = create :account_link, :gitlab
      expect(link.backend).to be_an(Appatite::Backends::Gitlab)
      expect(link.backend.base_url).to eq(setting.gitlab_url)
      expect(link.backend.app_id).to eq(setting.gitlab_id)
      expect(link.backend.app_secret).to eq(setting.gitlab_secret)
      expect(link.backend.token).to eq(link.secret)
    end

    it 'should create github backend' do
      setting = create :application_setting
      allow(ApplicationSetting).to receive(:current).and_return setting
      link = create :account_link, :github
      expect(link.backend).to be_an(Appatite::Backends::Github)
      expect(link.backend.app_id).to eq(setting.github_id)
      expect(link.backend.app_secret).to eq(setting.github_secret)
      expect(link.backend.token).to eq(link.secret)
    end

    it 'should raise exception on unsupported provider' do
      link = create :account_link, :github, provider: 'fail'
      expect { link.backend }.to raise_error(RuntimeError)
    end
  end
end
