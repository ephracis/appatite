# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'rubocop/rake_task'
require_relative 'config/application'

Rails.application.load_tasks

begin
  require 'rubocop/rake_task'
  require 'haml_lint/rake_task'
  require 'yamllint/rake_task'

  RuboCop::RakeTask.new

  HamlLint::RakeTask.new do |t|
    # t.config = 'path/to/custom/haml-lint.yml'
    t.files = %w(app/views/**/*.haml)
    # t.quiet = true # Don't display output from haml-lint
  end

  YamlLint::RakeTask.new do |t|
    t.paths = %w(**/*.yaml **/*.yml)
  end

  desc 'Run code style checks'
  task lint: %w(rubocop yamllint)

  task default: [:lint, :test]
rescue LoadError
  puts 'WARNING: Could not load test libraries, perhaps we are in production?'
end
