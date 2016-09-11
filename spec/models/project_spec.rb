require 'rails_helper'

describe Project, type: :model do
  let(:project) { create :project }
  let(:gitlab_backend) do
    Appatite::Backends::Gitlab.new(
      'https://example.com',
      'my-gitlab-id',
      'my-gitlab-secret',
      'my-gitlab-token'
    )
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    let(:http)  { 'http://example.com' }
    let(:https) { 'https://example.com' }
    let(:ftp)   { 'ftp://example.com' }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:origin) }
    it { is_expected.to validate_presence_of(:origin_id) }
    it { is_expected.to validate_uniqueness_of(:origin_id).scoped_to(:origin) }
    it { is_expected.to validate_presence_of(:api_url) }
    it { is_expected.to validate_uniqueness_of(:api_url) }
    it { is_expected.to allow_value(http).for(:api_url) }
    it { is_expected.to allow_value(https).for(:api_url) }
    it { is_expected.to_not allow_value(ftp).for(:api_url) }
  end

  describe '#refresh' do
    let(:project_api_response) do
      {
        name: 'foo/bar',
        state: 'my-state',
        description: 'My description.',
        coverage: '1.23'
      }
    end

    it 'should do nothing without origin' do
      project.origin = nil
      expect(project).to_not receive(:backend)
      project.refresh
    end

    it 'should fill meta data from backend' do
      expect(gitlab_backend).to \
        receive(:get_project).and_return(project_api_response)
      expect(project).to receive(:backend).and_return(gitlab_backend)
      project.refresh
      expect(project.name).to eq(project_api_response[:name])
    end
  end

  describe '#create_hook' do
    it 'should not run in development mode' do
      allow(Rails.env).to receive('development?').and_return true
      expect(project).to_not receive(:backend)
      project.create_hook 'http://example.com/hook'
    end

    it 'should ask backend to create hook' do
      expect(gitlab_backend).to receive(:create_webhook).with(
        'http://example.com',
        'http://example.com/hook'
      )
      expect(project).to receive(:backend).and_return(gitlab_backend)
      project.create_hook 'http://example.com/hook'
    end
  end

  describe '#delete_hook' do
    it 'should not run in development mode' do
      allow(Rails.env).to receive('development?').and_return true
      expect(project).to_not receive(:backend)
      project.delete_hook 'http://example.com/hook'
    end

    it 'should ask backend to delete hook' do
      expect(gitlab_backend).to receive(:delete_webhook).with(
        'http://example.com',
        'http://example.com/hook'
      )
      expect(project).to receive(:backend).and_return(gitlab_backend)
      project.delete_hook 'http://example.com/hook'
    end
  end

  describe '#receive_hook' do
    let(:hook_data) do
      {
        name: 'foo/bar',
        build_state: 'my-state',
        description: 'My description.',
        coverage: '13.37'
      }
    end

    it 'updates meta data' do
      expect(project).to receive(:backend).and_return(gitlab_backend)
      expect(gitlab_backend).to receive(:receive_webhook).and_return(hook_data)
      project.receive_hook nil
      expect(project.name).to eq(hook_data[:name])
      expect(project.build_state).to eq(hook_data[:build_state])
      expect(project.description).to eq(hook_data[:description])
      expect(project.coverage).to eq(hook_data[:coverage].to_i)
    end
  end
end
