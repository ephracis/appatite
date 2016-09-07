require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @project = projects(:gitlab_project)
    # request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test 'should not get index logged out' do
    get projects_url
    assert_redirected_to new_user_session_path
  end

  test 'should get index' do
    sign_in users(:alice)
    get projects_url
    assert_response :success
  end

  test 'index should redirect when no projects' do
    sign_in users(:bob)
    get projects_url
    assert_redirected_to setup_projects_path
  end

  test 'should not get setup logged out' do
    get setup_projects_path
    assert_redirected_to new_user_session_path
  end

  test 'should get setup' do
    stub_request(:get, 'https://api.github.com/user/repos')
      .to_return(body: [
        { id: 123, full_name: 'github/project2' }
      ].to_json)
    stub_request(:get, 'https://gitlab.com/api/v3/projects')
      .to_return(body: [
        { id: 123, path_with_namespace: 'gitlab/project1' }
      ].to_json)
    sign_in users(:alice)
    get setup_projects_path
    assert_response :success
    assert_select 'a', 'gitlab/project1'
    assert_select 'a', 'github/project2'
  end

  test 'should not get new logged out' do
    get new_project_url
    assert_redirected_to new_user_session_path
  end

  test 'should get new' do
    sign_in users(:alice)
    get new_project_url
    assert_response :success
  end

  test 'should not create project logged out' do
    assert_no_difference('Project.count') do
      post projects_url,
           params: {
             project: {
               build_state: @project.build_state,
               coverage: @project.coverage,
               name: @project.name
             }
           }
    end

    assert_redirected_to new_user_session_path
  end

  test 'should create github project' do
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
    stub_request(:post, 'https://api.github.com/repos/alice/test-repo/hooks')
      .with(body: {
        name: 'web',
        active: true,
        events: [:status],
        config: {
          url: 'http://www.example.com/projects/webhook',
          content_type: :json
        }
      }.to_json)
      .to_return(status: 201)

    sign_in users(:alice)
    assert_difference('Project.count') do
      post projects_url,
           params: {
             project: {
               origin: 'github',
               origin_id: 1337,
               api_url: 'https://api.github.com/repos/alice/test-repo'
             }
           }
    end

    assert_redirected_to project_url(Project.last)
    assert_equal project_data[:full_name], Project.last.name
    assert_equal project_data[:description], Project.last.description
    assert_equal statuses_data[0][:state], Project.last.build_state
  end

  test 'should create gitlab project' do
    project_data = {
      id: 1337,
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
    stub_request(:get, 'https://gitlab.com/api/v3/projects/1337')
      .to_return(body: project_data.to_json)
    stub_request(:get, 'https://gitlab.com/api/v3/projects/1337/builds')
      .to_return(body: builds_data.to_json)
    stub_request(:post, 'https://gitlab.com/api/v3/projects/1337/hooks')
      .with(body: {
        url: 'http://www.example.com/projects/webhook',
        pipeline_events: true
      }.to_json)
      .to_return(status: 201)

    sign_in users(:alice)
    assert_difference('Project.count') do
      post projects_url,
           params: {
             project: {
               origin: 'gitlab',
               origin_id: 1337,
               api_url: 'https://gitlab.com/api/v3/projects/1337'
             }
           }
    end

    assert_redirected_to project_url(Project.last)
    assert_equal project_data[:path_with_namespace], Project.last.name
    assert_equal project_data[:description], Project.last.description
    assert_equal builds_data[0][:status], Project.last.build_state
  end

  test 'should not create project without origin' do
    sign_in users(:alice)
    assert_no_difference('Project.count') do
      post projects_url,
           params: {
             project: {
               origin_id: 123,
               api_url: 'http://api.example.com/test',
               build_state: @project.build_state,
               coverage: @project.coverage,
               name: @project.name
             }
           }
    end

    assert_response :success
    assert_select 'li', "Origin can't be blank"
  end

  test 'should not show project logged out' do
    get project_url(@project)
    assert_redirected_to new_user_session_path
  end

  test 'should show project' do
    sign_in users(:alice)
    get project_url(@project)
    assert_response :success
  end

  test 'should not get edit logged out' do
    get edit_project_url(@project)
    assert_redirected_to new_user_session_path
  end

  test 'should get edit' do
    sign_in users(:alice)
    get edit_project_url(@project)
    assert_response :success
  end

  test 'should not update project logged out' do
    patch project_url(@project), params: { project: { build_state: @project.build_state, coverage: @project.coverage, name: @project.name } }
    assert_redirected_to new_user_session_path
  end

  test 'should update project' do
    sign_in users(:alice)
    patch project_url(@project), params: { project: { build_state: @project.build_state, coverage: @project.coverage, name: @project.name } }
    assert_redirected_to project_url(@project)
  end

  test 'should activate github project' do
    @project = projects(:github_project)
    stub_request(:post, "#{@project.api_url}/hooks").to_return(status: 201)
    @project.update_attribute(:active, false)

    sign_in users(:alice)
    patch project_url(@project), params: { project: { active: true } }

    assert_redirected_to project_url(@project)
    assert_requested :post, "#{@project.api_url}/hooks", body: {
      name: 'web',
      active: true,
      events: [:status],
      config: {
        url: 'http://www.example.com/projects/webhook',
        content_type: :json
      }
    }.to_json
  end

  test 'should activate gitlab project' do
    stub_request(:post, "#{@project.api_url}/hooks").to_return(status: 201)
    @project.update_attribute(:active, false)

    sign_in users(:alice)
    patch project_url(@project), params: { project: { active: true } }

    assert_redirected_to project_url(@project)
    assert_requested :post, "#{@project.api_url}/hooks", body: {
      url: 'http://www.example.com/projects/webhook',
      pipeline_events: true
    }.to_json
  end

  test 'should deactivate github project' do
    @project = projects(:github_project)
    stub_request(:get, "#{@project.api_url}/hooks")
      .to_return(body: [
        { id: 123, config: { url: 'http://example.com/test' } },
        { id: 42, config: { url: 'http://www.example.com/projects/webhook' } },
        { id: 321, config: { url: 'http://test.io/foobar' } }
      ].to_json)
    stub_request(:delete, "#{@project.api_url}/hooks/42")
      .to_return(status: 204)
    @project.update_attribute(:active, true)

    sign_in users(:alice)
    patch project_url(@project), params: { project: { active: false } }

    assert_redirected_to project_url(@project)
    assert_requested :get, "#{@project.api_url}/hooks"
    assert_requested :delete, "#{@project.api_url}/hooks/42"
  end

  test 'should deactivate gitlab project' do
    stub_request(:get, "#{@project.api_url}/hooks")
      .to_return(body: [
        { id: 123, url: 'http://example.com/test' },
        { id: 42, url: 'http://www.example.com/projects/webhook' },
        { id: 321, url: 'http://test.io/foobar' }
      ].to_json)
    stub_request(:delete, "#{@project.api_url}/hooks/42")
      .to_return(status: 204)
    @project.update_attribute(:active, true)

    sign_in users(:alice)
    patch project_url(@project), params: { project: { active: false } }

    assert_redirected_to project_url(@project)
    assert_requested :get, "#{@project.api_url}/hooks"
    assert_requested :delete, "#{@project.api_url}/hooks/42"
  end

  test 'should not remove origin from project' do
    sign_in users(:alice)
    patch project_url(@project), params: { project: {
      origin: nil
    } }
    assert_response :success
    assert_select 'li', "Origin can't be blank"
  end

  test 'should not remove origin_id from project' do
    sign_in users(:alice)
    patch project_url(@project), params: { project: {
      origin_id: nil
    } }
    assert_response :success
    assert_select 'li', "Origin ID can't be blank"
  end

  test 'should not remove api_url from project' do
    sign_in users(:alice)
    patch project_url(@project), params: { project: {
      api_url: nil
    } }
    assert_response :success
    assert_select 'li', "API URL can't be blank"
  end

  test 'should not destroy project logged out' do
    assert_no_difference('Project.count') do
      delete project_url(@project)
    end

    assert_redirected_to new_user_session_path
  end

  test 'should destroy github project' do
    @project = projects(:github_project)
    stub_request(:get, "#{@project.api_url}/hooks")
      .to_return(body: [
        { id: 123, config: { url: 'http://example.com/test' } },
        { id: 42, config: { url: 'http://www.example.com/projects/webhook' } },
        { id: 321, config: { url: 'http://test.io/foobar' } }
      ].to_json)
    stub_request(:delete, "#{@project.api_url}/hooks/42")
      .to_return(status: 204)
    sign_in users(:alice)
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
    assert_requested :get, "#{@project.api_url}/hooks"
    assert_requested :delete, "#{@project.api_url}/hooks/42"
  end

  test 'should destroy gitlab project' do
    stub_request(:get, "#{@project.api_url}/hooks")
      .to_return(body: [
        { id: 123, url: 'http://example.com/test' },
        { id: 42, url: 'http://www.example.com/projects/webhook' },
        { id: 321, url: 'http://test.io/foobar' }
      ].to_json)
    stub_request(:delete, "#{@project.api_url}/hooks/42")
      .to_return(status: 204)
    sign_in users(:alice)
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
    assert_requested :get, "#{@project.api_url}/hooks"
    assert_requested :delete, "#{@project.api_url}/hooks/42"
  end

  test 'should handle github hook' do
    with_forgery_protection do
      @project = projects(:github_project)
      hook_data = {
        state: 'pending',
        repository: {
          url: @project.api_url,
          full_name: 'alice/new-name',
          description: 'new description here'
        }
      }.to_json
      post webhook_projects_url, params: hook_data, headers: { 'X-GitHub-Event' => 'status' }
      assert_response :success
      assert_equal 'alice/new-name', Project.find(@project.id).name
      assert_equal 'running', Project.find(@project.id).build_state
    end
  end

  test 'should handle gitlab hook' do
    with_forgery_protection do
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
          id: 123,
          path_with_namespace: 'alice/new-name',
          description: 'new description here'
        }
      }.to_json
      post webhook_projects_url, params: hook_data
      assert_equal 'alice/new-name', Project.find(@project.id).name
      assert_equal 'running', Project.find(@project.id).build_state
    end
  end

  def with_forgery_protection
    old_value = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = old_value
  end
end
