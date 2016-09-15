require 'rails_helper'
require 'backends'

describe Appatite::Backends::Github, type: :lib do
  let(:backend) do
    Appatite::Backends::Github.new(
      'https://github.example.com',
      'my-github-test-id',
      'my-github-test-secret',
      'my-github-test-token'
    )
  end

  let(:repos_response) { json_response_file 'api/github/repos.json' }
  let(:repo_response) { json_response_file 'api/github/repo.json' }
  let(:statuses_response) { json_response '[]' }
  let(:hooks_response) { json_response_file 'api/github/hooks.json' }

  describe '#projects' do
    it 'should make get request to github api' do
      allow(backend).to receive(:get).and_return repos_response
      expect(backend.projects.length).to eq(1)
      expect(backend.projects[0][:url]).to eq('http://web.com/123')
      expect(backend.projects[0][:api_url]).to eq('http://api.com/123')
      expect(backend.projects[0][:id]).to eq('123')
      expect(backend.projects[0][:name]).to eq('sample/project')
      expect(backend.projects[0][:description]).to eq('my text')
      expect(backend.projects[0][:followers]).to eq(42)
    end
  end

  describe '#get_project' do
    before do
      allow(backend).to receive(:get)
        .with(1).and_return(repo_response)
      allow(backend).to receive(:get)
        .with('repos/sample/project/statuses/HEAD').and_return(statuses_response)
    end

    it 'should parse name' do
      expect(backend.get_project(1)[:name]).to eq('sample/project')
    end

    it 'should parse description' do
      expect(backend.get_project(1)[:description]).to eq('my text')
    end

    context "when project doesn't have builds" do
      it 'should skip build state' do
        expect(backend.get_project(1)[:build_state]).to eq(nil)
      end

      it 'should skip code coverage' do
        expect(backend.get_project(1)[:coverage]).to eq(nil)
      end
    end

    context 'when project has statuses' do
      it "should parse build state 'pending' as 'running'" do
        expect(backend).to receive(:get)
          .with('repos/sample/project/statuses/HEAD')
          .and_return(json_response([{ state: 'pending' }]))
        expect(backend.get_project(1)[:state]).to eq('running')
      end

      it "should parse build state 'failed'" do
        expect(backend).to receive(:get)
          .with('repos/sample/project/statuses/HEAD')
          .and_return(json_response([{ state: 'failed' }]))
        expect(backend.get_project(1)[:state]).to eq('failed')
      end

      it "should parse build state 'error' as 'failed'" do
        expect(backend).to receive(:get)
          .with('repos/sample/project/statuses/HEAD')
          .and_return(json_response([{ state: 'error' }]))
        expect(backend.get_project(1)[:state]).to eq('failed')
      end

      it "should parse build state 'success'" do
        expect(backend).to receive(:get)
          .with('repos/sample/project/statuses/HEAD')
          .and_return(json_response([{ state: 'success' }]))
        expect(backend.get_project(1)[:state]).to eq('success')
      end

      it "should parse arbitrary build state as 'unknown'" do
        expect(backend).to receive(:get)
          .with('repos/sample/project/statuses/HEAD')
          .and_return(json_response([{ state: 'foobar' }]))
        expect(backend.get_project(1)[:state]).to eq('unknown')
      end
    end
  end

  describe '#create_webhook' do
    it 'should make post request to api' do
      expect(backend).to receive(:post).with(
        'project-url/hooks',
        body: {
          name: 'web',
          active: true,
          events: [:status],
          config: {
            url: 'hook-url',
            content_type: :json
          }
        }.to_json
      )
      backend.create_webhook 'project-url', 'hook-url'
    end
  end

  describe '#delete_webhook' do
    before do
      expect(backend).to receive(:get).with('project-url/hooks')
        .and_return(hooks_response)
    end

    context 'when webhook exists' do
      it 'should delete the webhook' do
        expect(backend).to receive(:delete).with('project-url/hooks/123')
        backend.delete_webhook('project-url', 'http://example.com/hook')
      end
    end

    context 'when no webhook exists' do
      it 'should do nothing' do
        expect(backend).to_not receive(:delete)
        backend.delete_webhook('project-url', 'invalid-url')
      end
    end
  end

  describe '#receive_webhook' do
    let(:payload) do
      JSON.parse({
        state: 'pending',
        repository: {
          full_name: 'foo/bar',
          description: 'foo bar.'
        }
      }.to_json)
    end

    before do
      allow(backend).to receive(:get)
        .with(1).and_return(repo_response)
      allow(backend).to receive(:get)
        .with('/api/v3/projects/123/builds').and_return(statuses_response)
    end

    it 'should parse project name' do
      expect(backend.receive_webhook(payload)[:name]).to eq('foo/bar')
    end

    it 'should parse project description' do
      expect(backend.receive_webhook(payload)[:description]).to eq('foo bar.')
    end

    it 'should parse build state' do
      expect(backend.receive_webhook(payload)[:build_state]).to eq('running')
    end
  end
end
