require 'test_helper'

class WishesControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wishes)
  end

  test "should show wish" do
    get :show, id: @teapot
    assert_response :success
    assert_equal(assigns(:wish).title, @teapot.title)
  end
end
