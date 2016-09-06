require 'test_helper'

class AccountLinkTest < ActiveSupport::TestCase
  test 'should create account link' do
    link = AccountLink.new(
      user: users(:alice),
      provider: 'test',
      uid: 'test'
    )
    assert link.save
  end

  test 'should not create account link without user' do
    link = AccountLink.new(
      provider: 'test',
      uid: 'test'
    )
    assert !link.save
  end

  test 'should not create account link without provider' do
    link = AccountLink.new(
      user: users(:alice),
      uid: 'test'
    )
    assert !link.save
  end

  test 'should not create account link without uid' do
    link = AccountLink.new(
      user: users(:alice),
      provider: 'test'
    )
    assert !link.save
  end

  test 'should not create link with existing provider and uid' do
    link = AccountLink.new(
      user: users(:bob),
      provider: account_links(:link1).provider,
      uid: account_links(:link1).uid
    )
    assert !link.save
  end

  test 'should get gitlab projects' do
    stub_request(:get, 'https://gitlab.com/api/v3/projects')
      .to_return(body: [{ id: 42 }, { id: 1337 }].to_json)
    link = AccountLink.new(
      user: users(:alice),
      provider: 'gitlab',
      uid: 'test',
      token: 'mytoken'
    )
    assert_equal 2, link.projects.count
    assert_equal 42, link.projects[0][:id]
    assert_equal 1337, link.projects[1][:id]
  end

  test 'should get github projects' do
    stub_request(:get, 'https://api.github.com/user/repos')
      .to_return(body: [{ id: 42 }, { id: 1337 }].to_json)
    link = AccountLink.new(
      user: users(:alice),
      provider: 'github',
      uid: 'test',
      token: 'mytoken'
    )
    assert_equal 2, link.projects.count
    assert_equal 42, link.projects[0][:id]
    assert_equal 1337, link.projects[1][:id]
  end
end
