require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should not create project without origin' do
    project = Project.new(
      name: 'test',
      origin_id: 123,
      api_url: 'http://api.com/test',
      user: users(:bob)
    )
    assert !project.save, 'Saved without origin'
  end

  test 'should not create project without origin_id' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      api_url: 'http://api.com/test',
      user: users(:bob)
    )
    assert !project.save, 'Saved without origin_id'
  end

  test 'should not create project without user' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      origin_id: 123,
      api_url: 'http://api.com/test'
    )
    assert !project.save, 'Saved without user'
  end

  test 'should not create project without api_url' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      origin_id: 123,
      user: users(:bob)
    )
    assert !project.save, 'Saved without api_url'
  end

  test 'should not create project with existing origin and origin_id' do
    existing_project = Project.first
    project = Project.new(
      name: 'test',
      origin: existing_project.origin,
      origin_id: existing_project.origin_id
    )
    assert !project.save, 'Saved duplicate project'
  end

  test 'should create project' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      api_url: 'http://api.com/test',
      origin_id: 123,
      user: users(:bob)
    )
    assert project.save, 'Did not save project'
  end

  test 'should refresh github project meta data' do
    project_data = {
      id: 123,
      full_name: 'alice/test-repo',
      description: 'this is a github repo'
    }
    statuses_data = [
      {
        state: 'failed'
      },
      {
        state: 'success'
      }
    ]
    stub_request(:get, 'https://api.github.com/repos/alice/test-repo')
      .to_return(body: project_data.to_json)
    stub_request(:get, 'https://api.github.com/repos/alice/test-repo/statuses/HEAD')
      .to_return(body: statuses_data.to_json)

    project = Project.new(
      api_url: 'https://api.github.com/repos/alice/test-repo',
      origin: 'github',
      user: users(:alice)
    )
    project.refresh

    assert_equal project_data[:full_name], project.name
    assert_equal statuses_data[0][:state], project.build_state
    assert_equal project_data[:description], project.description
  end

  test 'should refresh gitlab project meta data' do
    project_data = {
      id: 123,
      path_with_namespace: 'test-name',
      state: 'test-state',
      description: 'this is a gitlab repo'
    }
    builds_data = [
      {
        coverage: '42',
        status: 'failed'
      },
      {
        coverage: '30',
        status: 'success'
      }
    ]
    stub_request(:get, 'https://gitlab.com/api/v3/projects/123')
      .to_return(body: project_data.to_json)
    stub_request(:get, 'https://gitlab.com/api/v3/projects/123/builds')
      .to_return(body: builds_data.to_json)

    project = Project.new(
      api_url: 'https://gitlab.com/api/v3/projects/123',
      origin: 'gitlab',
      user: users(:alice)
    )
    project.refresh

    assert_equal project_data[:path_with_namespace], project.name
    assert_equal project_data[:description], project.description
    assert_equal builds_data[0][:status], project.build_state
    assert_equal builds_data[0][:coverage], project.coverage.to_s
  end

  test 'should create github webhook' do
    stub_request(:post, 'https://api.github.com/repos/alice/test-repo/hooks')
      .with(body: {
        name: 'web',
        active: true,
        events: [:status],
        config: {
          url: 'http://example.com/projects/webhook',
          content_type: :json
        }
      }.to_json)
      .to_return(status: 201)

    project = Project.new(
      api_url: 'https://api.github.com/repos/alice/test-repo',
      origin: 'github',
      user: users(:alice)
    )
    assert project.create_hook('http://example.com/projects/webhook'),
           'Did not create webhook'
  end

  test 'should delete github webhook' do
    stub_request(:get, 'https://api.github.com/repos/alice/test-repo/hooks')
      .to_return(body: [
        { id: 123, config: { url: 'http://example.com/test' } },
        { id: 42, config: { url: 'http://example.com/projects/webhook' } },
        { id: 321, config: { url: 'http://test.io/foobar' } }
      ].to_json)
    stub_request(:delete, 'https://api.github.com/repos/alice/test-repo/hooks/42')
      .to_return(status: 204)

    project = Project.new(
      api_url: 'https://api.github.com/repos/alice/test-repo',
      origin: 'github',
      user: users(:alice)
    )
    assert project.delete_hook('http://example.com/projects/webhook'),
           'Did not delete webhook'
  end

  test 'should create gitlab webhook' do
    stub_request(:post, 'https://gitlab.com/api/v3/projects/123/hooks')
      .with(body: {
        url: 'http://example.com/projects/webhook',
        pipeline_events: true
      }.to_json)
      .to_return(status: 201)

    project = Project.new(
      api_url: 'https://gitlab.com/api/v3/projects/123',
      origin: 'gitlab',
      user: users(:alice)
    )
    assert project.create_hook('http://example.com/projects/webhook'),
           'Did not create webhook'
  end

  test 'should delete gitlab webhook' do
    stub_request(:get, 'https://gitlab.com/api/v3/projects/123/hooks')
      .to_return(body: [
        { id: 123, url: 'http://example.com/test' },
        { id: 42, url: 'http://example.com/projects/webhook' },
        { id: 321, url: 'http://test.io/foobar' }
      ].to_json)
    stub_request(:delete, 'https://gitlab.com/api/v3/projects/123/hooks/42')
      .to_return(status: 204)

    project = Project.new(
      api_url: 'https://gitlab.com/api/v3/projects/123',
      origin: 'gitlab',
      user: users(:alice)
    )
    assert project.delete_hook('http://example.com/projects/webhook'),
           'Did not delete webhook'
  end

  test 'should receive github status webhook' do
    project = Project.new(
      api_url: 'https://api.github.com/repos/alice/test-repo',
      origin: 'github',
      user: users(:alice)
    )
    hook_data = {
      state: 'pending',
      repository: {
        full_name: 'alice/new-name',
        description: 'new description here'
      }
    }.to_json

    project.receive_hook(JSON.parse(hook_data))

    assert_equal 'alice/new-name', project.name
    assert_equal 'running', project.build_state
    assert_equal 'new description here', project.description
  end

  test 'should receive gitlab pipeline webhook' do
    project = Project.new(
      api_url: 'https://gitlab.com/api/v3/projects/123',
      origin: 'gitlab',
      user: users(:alice)
    )
    hook_data = {
      builds: [
        {
          status: 'running'
        },
        {
          status: 'success'
        }
      ],
      project: {
        path_with_namespace: 'alice/new-name',
        description: 'new description here'
      }
    }.to_json

    project.receive_hook(JSON.parse(hook_data))

    assert_equal 'alice/new-name', project.name
    assert_equal 'running', project.build_state
    assert_equal 'new description here', project.description
  end

  test 'should raise when creating hook on unsupported provider' do
    project = Project.new(
      origin: 'test'
    )
    assert_raises RuntimeError do
      project.create_hook('test')
    end
  end

  test 'should raise when deleting hook on unsupported provider' do
    project = Project.new(
      origin: 'test'
    )
    assert_raises RuntimeError do
      project.delete_hook('test')
    end
  end

  test 'should raise when fetching metadata from unsupported provider' do
    project = Project.new(
      origin: 'test'
    )
    assert_raises RuntimeError do
      project.send(:fetch_metadata)
    end
  end

  test 'should raise when getting url for unsupported provider' do
    project = Project.new(
      origin: 'test'
    )
    assert_raises RuntimeError do
      project.send(:provider_url)
    end
  end
end
