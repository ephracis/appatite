require 'rails_helper'

describe Project, type: :model do
  let(:project) { create :project }
  let(:backend) do
    Appatite::Backends::Gitlab.new(
      'https://example.com',
      'my-gitlab-id',
      'my-gitlab-secret',
      'my-gitlab-token'
    )
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:commits) }
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
    let(:backend_project) do
      {
        name: 'foo/bar',
        state: 'my-state',
        description: 'My description.',
        coverage: '1.23',
        commits: [
          {
            sha: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1',
            user: {
              email: 'foo@mail.com',
              name: 'Mr Foo'
            }
          },
          {
            sha: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa2',
            user: {
              email: 'bar@mail.com',
              name: 'Mrs Bar'
            }
          }
        ]
      }
    end

    let(:commits_response) { json_response_file 'api/github/commits.json' }

    it 'should do nothing without origin' do
      expect(project).to_not receive(:backend)
      project.origin = nil
      project.refresh
    end

    it 'should fill meta data from backend' do
      expect(project).to receive(:backend).and_return(backend)
      expect(backend).to \
        receive(:get_project).and_return(backend_project)
      expect { project.refresh }.to \
        change { project.commits.count }.by(backend_project[:commits].count)
      expect(project.name).to eq(backend_project[:name])
      expect(project.commits.first.sha).to \
        eq(backend_project[:commits][0][:sha])
    end
  end

  describe '#create_hook' do
    it 'should not run in development mode' do
      expect(project).to_not receive(:backend)
      allow(Rails.env).to receive('development?').and_return true
      project.create_hook 'http://example.com/hook'
    end

    it 'should ask backend to create hook' do
      expect(project).to receive(:backend).and_return(backend)
      expect(backend).to receive(:create_webhook).with(
        'http://example.com',
        'http://example.com/hook'
      )
      project.create_hook 'http://example.com/hook'
    end
  end

  describe '#delete_hook' do
    it 'should not run in development mode' do
      expect(project).to_not receive(:backend)
      allow(Rails.env).to receive('development?').and_return true
      project.delete_hook 'http://example.com/hook'
    end

    it 'should ask backend to delete hook' do
      expect(project).to receive(:backend).and_return(backend)
      expect(backend).to receive(:delete_webhook).with(
        'http://example.com',
        'http://example.com/hook'
      )
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
      expect(project).to receive(:backend).and_return(backend)
      expect(backend).to receive(:receive_webhook).and_return(hook_data)
      project.receive_hook nil
      expect(project.name).to eq(hook_data[:name])
      expect(project.build_state).to eq(hook_data[:build_state])
      expect(project.description).to eq(hook_data[:description])
      expect(project.coverage).to eq(hook_data[:coverage].to_i)
    end
  end
end
