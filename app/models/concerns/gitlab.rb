require 'active_support/concern'

module Gitlab
  extend ActiveSupport::Concern

  def gitlab_projects
    resp = open("https://gitlab.com/api/v3/projects?access_token=#{token}").read
    JSON.parse(resp).map do |project|
      {
        id: project['id'],
        name: project['path_with_namespace'],
        description: project['description'],
        url: project['web_url'],
        followers: project['star_count'],
        origin: :gitlab
      }
    end
  end

  def gitlab_url
    'https://gitlab.com/api/v3/'
  end
end
