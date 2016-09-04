require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @project = projects(:project1)
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
    sign_in users(:alice)
    get setup_projects_path
    assert_response :success
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

  test 'should create project' do
    sign_in users(:alice)
    assert_difference('Project.count') do
      post projects_url,
           params: {
             project: {
               origin: 'test',
               origin_id: 123,
               build_state: @project.build_state,
               coverage: @project.coverage,
               name: @project.name
             }
           }
    end

    assert_redirected_to project_url(Project.last)
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
    assert_select 'li', "Origin can't be blank"
  end

  test 'should not destroy project logged out' do
    assert_no_difference('Project.count') do
      delete project_url(@project)
    end

    assert_redirected_to new_user_session_path
  end

  test 'should destroy project' do
    sign_in users(:alice)
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end
end
