require 'rails_helper'
require 'backends'

describe Appatite::Backends::Base, type: :lib do
  let(:backend) do
    Appatite::Backends::Base.new(
      'http://example.com',
      'my-test-id',
      'my-test-secret',
      'my-test-token'
    )
  end

  let(:client) do
    OAuth2::Client.new 'my-id', 'my-secret', site: 'http://foo.io'
  end

  let(:access_token) do
    OAuth2::AccessToken.new client, 'my-token'
  end

  before do
    allow(OAuth2::AccessToken).to receive(:new).and_return(access_token)
    allow(OAuth2::Client).to receive(:new).and_return(client)
    allow_any_instance_of(OAuth2::Client).to \
      receive(:request)
  end

  describe '#request' do
    it 'should create an oauth2 client' do
      backend.request :get, '/test/path'
    end

    it 'should cache oauth2 client between calls' do
      expect(OAuth2::Client).to receive(:new).once.and_return(client)
      backend.request :get, '/test/path'
      backend.request :get, '/second/path'
    end

    it 'should create an oauth2 access token' do
      backend.request :get, '/test/path'
    end

    it 'should cache oauth2 access token between calls' do
      expect(OAuth2::Client).to receive(:new).once.and_return(access_token)
      backend.request :get, '/test/path'
      backend.request :get, '/second/path'
    end

    it 'should delegate request to oauth2 access token' do
      expect(access_token).to receive(:request).with(:get, '/test/path')
      backend.request :get, '/test/path'
    end
  end

  describe '#get, #post, #put #patch, #delete' do
    it 'should delegate request to oauth2 access token' do
      expect(access_token).to receive(:get).with('/test/path/get', {})
      expect(access_token).to receive(:post).with('/test/path/post', {})
      expect(access_token).to receive(:put).with('/test/path/put', {})
      expect(access_token).to receive(:patch).with('/test/path/patch', {})
      expect(access_token).to receive(:delete).with('/test/path/delete', {})
      backend.get '/test/path/get'
      backend.post '/test/path/post'
      backend.put '/test/path/put'
      backend.patch '/test/path/patch'
      backend.delete '/test/path/delete'
    end
  end
end
