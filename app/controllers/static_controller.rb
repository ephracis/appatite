class StaticController < ApplicationController
  def index
  end

  def about
    l = current_user.account_links.find_by(provider: :github)
    project = JSON.parse(l.send(:get, 'https://api.github.com/repos/ephracis/appatite').body)
    name = project['full_name']
    statuses = JSON.parse(l.send(:get, "/repos/#{name}/statuses/HEAD").body)
    if statuses.length.positive?
      render json: statuses[0]['state']
    else
      render json: { error: 'no statuses' }
    end
  end
end
