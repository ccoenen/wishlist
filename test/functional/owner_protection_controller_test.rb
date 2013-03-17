require 'test_helper'

class OwnerProtectionControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should set a cookie to prevent seeing all wishes" do
    get :owner
    assert_equal false, cookies[:visitor], "the visitor cookie should be set and false"
  end

  test "should set a cookie to enable visitors to see all wishes" do
    get :visitor
    assert_equal true, cookies[:visitor], "the visitor cookie should be set and true"
  end
end
