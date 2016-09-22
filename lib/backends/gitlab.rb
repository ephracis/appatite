module Appatite::Backends
  class Gitlab < Base
    def projects
      JSON.parse(get('/api/v3/projects').body).map do |project|
        {
          url: project['web_url'],
          api_url: "#{base_url}/api/v3/projects/#{project['id']}",
          id: project['id'],
          name: project['path_with_namespace'],
          description: project['description'],
          followers: project['star_count'].to_i,
          origin: :gitlab
        }
      end
    end

    def get_project(url)
      project = JSON.parse(get(url).body)
      builds = JSON.parse(get("/api/v3/projects/#{project['id']}/builds").body)
      commits = JSON.parse(get("/api/v3/projects/#{project['id']}/commits").body)
      data = parse_project project
      parse_builds data, builds
      data[:commits] = parse_commits commits
      data
    end

    def create_webhook(project_url, hook_url)
      hook_data = {
        url: hook_url,
        pipeline_events: true
      }
      post("#{project_url}/hooks", body: hook_data.to_json)
    end

    def delete_webhook(project_url, hook_url)
      hooks = JSON.parse(get("#{project_url}/hooks").body)
      hook = hooks.find { |h| h['url'] == hook_url }
      delete("#{project_url}/hooks/#{hook['id']}") if hook
    end

    def receive_webhook(payload)
      parsed_data = {
        name: payload['project']['path_with_namespace'],
        description: payload['project']['description']
      }
      if payload['builds'] && payload['builds'].length.positive?
        parsed_data[:build_state] = translate_status(payload['builds'][0]['status'])
      end
      parsed_data
    end

    private

    def translate_status(state)
      case state
      when 'pending', 'running' then 'running'
      when 'failed' then 'failed'
      when 'success' then 'success'
      else 'unknown'
      end
    end

    def parse_project(project)
      {
        name: project['path_with_namespace'],
        description: project['description']
      }
    end

    def parse_builds(data, builds)
      data[:state] = translate_status(builds[0]['status']) if builds.length.positive?
      data[:coverage] = builds[0]['coverage'] if builds.length.positive?
    end

    def parse_commits(commits)
      return unless commits && commits.length.positive?
      commits.map do |commit|
        {
          sha: commit['id'],
          message: commit['message'],
          created_at: commit['created_at'],
          user: {
            email: commit['author_email'],
            name: commit['author_name']
          }
        }
      end
    end
  end
end
