require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  fixtures :all

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  def teardown
    WebMock.allow_net_connect!
  end
end
