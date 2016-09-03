require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should not get overview logged out' do
    get admin_overview_url
    assert_redirected_to new_user_session_path
  end

  test 'should not get users logged out' do
    get admin_users_url
    assert_redirected_to new_user_session_path
  end

  test 'should not get projects logged out' do
    get admin_projects_url
    assert_redirected_to new_user_session_path
  end

  test 'should not get settings logged out' do
    get admin_settings_url
    assert_redirected_to new_user_session_path
  end

  test 'should not get overview as user' do
    sign_in users(:alice)
    get admin_overview_url
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select 'div', 'You are not allowed to do that.'
  end

  test 'should not get users as user' do
    sign_in users(:alice)
    get admin_users_url
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select 'div', 'You are not allowed to do that.'
  end

  test 'should not get projects as user' do
    sign_in users(:alice)
    get admin_projects_url
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select 'div', 'You are not allowed to do that.'
  end

  test 'should not get settings as user' do
    sign_in users(:alice)
    get admin_settings_url
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select 'div', 'You are not allowed to do that.'
  end

  test 'should get overview as admin' do
    sign_in users(:admin)
    get admin_overview_url
    assert_response :success
  end

  test 'should get users as admin' do
    sign_in users(:admin)
    get admin_users_url
    assert_response :success
  end

  test 'should get projects as admin' do
    sign_in users(:admin)
    get admin_projects_url
    assert_response :success
  end

  test 'should get settings as admin' do
    sign_in users(:admin)
    get admin_settings_url
    assert_response :success
  end
end
