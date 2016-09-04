require 'active_support/concern'

module Github
  extend ActiveSupport::Concern

  def github_projects
    resp = get('/user/repos').body.to_s
    JSON.parse(resp).map do |project|
      {
        id: project['id'],
        name: project['full_name'],
        description: project['description'],
        url: project['html_url'],
        followers: project['watchers'],
        origin: :github
      }
    end
  end

  def github_url
    'https://api.github.com/'
  end
end
