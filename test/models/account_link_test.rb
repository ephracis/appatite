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
end
