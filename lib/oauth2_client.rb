class Appatite::Oauth2Client
  attr_accessor :base_url
  attr_accessor :app_id
  attr_accessor :app_secret
  attr_accessor :token

  def initialize(base_url, app_id, app_secret, token)
    self.base_url = base_url
    self.app_id = app_id
    self.app_secret = app_secret
    self.token = token
  end

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

  private

  def client
    return @client if @client
    @client = OAuth2::Client.new(app_id, app_secret, site: base_url)
  end

  def access_token
    return @access_token if @access_token
    @access_token = OAuth2::AccessToken.new(client, token)
  end
end
