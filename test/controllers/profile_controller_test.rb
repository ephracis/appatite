require 'test_helper'

class Users::ProfileControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:alice)
  end

  test 'should not get profile logged out' do
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should not edit profile logged out' do
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end

  test 'should get profile' do
    sign_in @user
    get user_path(@user)
    assert_response :success
  end

  test 'should edit profile' do
    sign_in @user
    get edit_user_path(@user)
    assert_response :success
  end

  test 'should not toggle admin logged out' do
    patch toggle_admin_path(@user, format: :json)
    assert_response :unauthorized
  end

  test 'should not toggle admin as user' do
    sign_in @user
    patch toggle_admin_path(@user, format: :json)
    assert_response :forbidden
  end

  test 'should toggle admin as admin' do
    sign_in users(:admin)
    patch toggle_admin_path(@user, format: :json)
    assert_response :success
  end

  test 'should not toggle last admin' do
    sign_in users(:admin)
    patch toggle_admin_path(users(:admin), format: :json)
    assert_response :unprocessable_entity
  end

  test 'should not update profile logged out' do
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to new_user_session_path
  end

  test 'should update profile' do
    sign_in @user
    patch user_url(@user), params: { user: { name: @user.name } }
    assert_redirected_to user_url(@user)
  end

  test 'should not update someone elses profile' do
    user = users(:alice)
    other_user = users(:bob)
    sign_in user
    patch user_url(other_user), params: { user: { name: 'New Name' } }
    assert_redirected_to user_url(user)
    assert_equal 'New Name', User.find(user.id).name
    assert_not_equal 'New Name', User.find(other_user.id).name
  end

  test 'should update someone elses profile when admin' do
    sign_in users(:admin)
    patch user_url(users(:bob)), params: { user: { name: 'New Name' } }
    assert_redirected_to user_path(users(:bob).id)
    assert_equal 'New Name', User.find(users(:bob).id).name
  end
end
