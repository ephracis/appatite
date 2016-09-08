require 'oauth2_client'

module Appatite::Backends
  class Gitlab < ::Appatite::Oauth2Client
    def projects
      JSON.parse(get('/api/v3/projects').body).map do |project|
        {
          url: project['web_url'],
          api_url: "#{base_url}/api/v3/projects/#{project['id']}",
          id: project['id'],
          name: project['path_with_namespace'],
          description: project['description'],
          followers: project['star_count'],
          origin: :gitlab
        }
      end
    end

    def get_project(url)
      project = JSON.parse(get(url).body)
      builds = JSON.parse(get("/api/v3/projects/#{project['id']}/builds").body)
      retval = {
        name: project['path_with_namespace'],
        description: project['description']
      }
      if builds.length.positive?
        retval[:state] = builds[0]['status']
        retval[:coverage] = builds[0]['coverage']
      end
      retval
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
      if payload['builds'].length.positive?
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
  end
end
