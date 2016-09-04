require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should not create project without origin' do
    project = Project.new(
      name: 'test',
      origin_id: 123,
      user: users(:bob)
    )
    assert !project.save, 'Saved without origin'
  end

  test 'should not create project without origin_id' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      user: users(:bob)
    )
    assert !project.save, 'Saved without origin_id'
  end

  test 'should not create project without user' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      origin_id: 123
    )
    assert !project.save, 'Saved without user'
  end

  test 'should not create project with existing origin and origin_id' do
    existing_project = Project.first
    project = Project.new(
      name: 'test',
      origin: existing_project.origin,
      origin_id: existing_project.origin_id
    )
    assert !project.save, 'Saved duplicate project'
  end

  test 'should create project' do
    project = Project.new(
      name: 'test',
      origin: 'test',
      origin_id: 123,
      user: users(:bob)
    )
    assert project.save, 'Did not save project'
  end
end
