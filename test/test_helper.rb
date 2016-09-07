require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'
require 'mocha/mini_test'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  fixtures :all

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def teardown
    WebMock.reset!
    WebMock.allow_net_connect!
  end
end

class ActionDispatch::IntegrationTest
  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def teardown
    WebMock.reset!
    WebMock.allow_net_connect!
  end
end
