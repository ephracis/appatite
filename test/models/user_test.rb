require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not create user with non-unique email' do
    user = User.new email: users(:alice).email
    assert !user.save
  end

  test 'should create user with unique email' do
    user = User.new email: 'test@mail.com'
    assert user.save
  end
end
