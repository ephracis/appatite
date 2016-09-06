require 'active_support/concern'

module OauthClient
  extend ActiveSupport::Concern

  def request(http_method, path, *arguments)
    access_token.request(http_method, path, *arguments)
  end

  def get(path, opts = {}, &block)
    access_token.get(path, opts, &block)
  end

  def head(path, opts = {}, &block)
    access_token.head(path, opts, &block)
  end

  def post(path, opts = {}, &block)
    access_token.post(path, opts, &block)
  end

  def put(path, opts = {}, &block)
    access_token.put(path, opts, &block)
  end

  def patch(path, opts = {}, &block)
    access_token.patch(path, opts, &block)
  end

  def delete(path, opts = {}, &block)
    access_token.delete(path, opts, &block)
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
