require 'test_helper'

class Admin::ApplicationSettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should not get show logged out' do
    get admin_application_settings_path
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should not get show as user' do
    sign_in users(:alice)
    get admin_application_settings_path
    assert_response :not_found
    assert_select 'h1', '404'
  end

  test 'should get show as admin' do
    sign_in users(:admin)
    get admin_application_settings_path
    assert_response :success
  end
end
