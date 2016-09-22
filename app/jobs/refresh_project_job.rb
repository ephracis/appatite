class RefreshProjectJob < ApplicationJob
  queue_as :default

  def perform(project)
    project.refresh
  end
end
