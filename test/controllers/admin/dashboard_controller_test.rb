require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should not get index logged out' do
    get admin_root_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get users logged out' do
    get admin_users_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get projects logged out' do
    get admin_projects_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get index as user' do
    sign_in users(:alice)
    get admin_root_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get users as user' do
    sign_in users(:alice)
    get admin_users_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get projects as user' do
    sign_in users(:alice)
    get admin_projects_url
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should get index as admin' do
    sign_in users(:admin)
    get admin_root_url
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
end
