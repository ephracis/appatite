require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_path
    assert_response :success
    assert_select 'a.navbar-brand', 'Appatite'
    assert_select 'a.btn', 'Get started'
  end

  test 'should get pricing' do
    get pricing_path
    assert_response :success
    assert_select 'div.panel-heading', 'Open Source'
    assert_select 'div.panel-heading', 'Standard'
    assert_select 'div.panel-heading', 'Premium'
    assert_select 'h2.panel-headline', 'Free'
  end
end
