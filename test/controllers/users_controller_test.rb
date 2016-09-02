require 'test_helper'

module Users
  class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:alice)
      @link = account_links(:link1)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123545',
        info: {
          email: 'test@mail.com',
          name: 'Test User',
          image: 'test'
        }
      )
      OmniAuth.config.mock_auth[:gitlab] = OmniAuth::AuthHash.new(
        provider: 'gitlab',
        uid: '123545',
        info: {
          email: 'test@mail.com',
          name: 'Test User',
          image: 'test'
        }
      )
    end

    test 'should create new user from github' do
      get '/users/auth/github'
      assert_difference 'User.count' do
        assert_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Github account.'
    end

    test 'should sign_in existing user from github' do
      OmniAuth.config.mock_auth[:github][:info][:email] = @user.email
      get '/users/auth/github'
      assert_no_difference 'User.count' do
        assert_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Github account.'
    end

    test 'should sign_in pre-authenticated user from github' do
      OmniAuth.config.mock_auth[:github][:info][:email] = @link.user.email
      OmniAuth.config.mock_auth[:github][:provider] = @link.provider
      OmniAuth.config.mock_auth[:github][:uid] = @link.uid
      get '/users/auth/github'
      assert_no_difference 'User.count' do
        assert_no_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Github account.'
    end

    test 'should create new user from gitlab' do
      get '/users/auth/gitlab'
      assert_difference 'User.count' do
        assert_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Gitlab account.'
    end

    test 'should sign_in existing user from gitlab' do
      OmniAuth.config.mock_auth[:gitlab][:info][:email] = @user.email
      get '/users/auth/gitlab'
      assert_no_difference 'User.count' do
        assert_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Gitlab account.'
    end

    test 'should sign_in pre-authenticated user from gitlab' do
      OmniAuth.config.mock_auth[:gitlab][:info][:email] = @link.user.email
      OmniAuth.config.mock_auth[:gitlab][:provider] = @link.provider
      OmniAuth.config.mock_auth[:gitlab][:uid] = @link.uid
      get '/users/auth/gitlab'
      assert_no_difference 'User.count' do
        assert_no_difference 'AccountLink.count' do
          follow_redirect!
        end
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_response :success
      assert_select 'div', 'Successfully authenticated from Gitlab account.'
    end

    test 'should redirect to login on failure' do
      OmniAuth.config.mock_auth[:gitlab] = :invalid_credentials
      get '/users/auth/gitlab'
      OmniAuth.config.logger = Logger.new('/dev/null')
      follow_redirect!
      assert_redirected_to new_user_session_path
    end
  end
end
