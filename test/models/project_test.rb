require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should create project' do
    project = Project.new(name: 'test')
    assert project.save
  end
end
