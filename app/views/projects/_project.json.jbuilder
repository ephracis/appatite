json.extract! project, :id, :name, :origin, :origin_id, :api_url, :active, :coverage, :build_state, :refreshed_at, :created_at, :updated_at
json.url project_url(project, format: :json)
