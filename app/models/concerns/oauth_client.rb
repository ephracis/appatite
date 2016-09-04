require 'active_support/concern'

module OauthClient
  extend ActiveSupport::Concern

  def request(http_method, path, *arguments)
    access_token.request(http_method, path, *arguments)
  end

  def get(path, headers = {})
    request(:get, path, headers)
  end

  def head(path, headers = {})
    request(:head, path, headers)
  end

  def post(path, body = '', headers = {})
    request(:post, path, body, headers)
  end

  def put(path, body = '', headers = {})
    request(:put, path, body, headers)
  end

  def patch(path, body = '', headers = {})
    request(:patch, path, body, headers)
  end

  def delete(path, headers = {})
    request(:delete, path, headers)
  end

  def client
    return @client if @client
    @client = OAuth2::Client.new(
      ENV["#{provider.upcase}_ID"],
      ENV["#{provider.upcase}_SECRET"],
      site: provider_url
    )
  end

  def access_token
    return @access_token if @access_token
    @access_token = OAuth2::AccessToken.new(client, token)
  end

  def provider_url
    raise "Unsupported OAuth provider #{provider}"
  end
end
