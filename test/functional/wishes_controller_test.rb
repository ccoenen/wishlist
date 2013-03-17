require 'test_helper'

class WishesControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
    @teaspoon = wishes(:taken_teaspoon)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wishes)
    assert assigns(:wishes).include?(@teapot)
    assert assigns(:wishes).include?(@teaspoon) # when in doubt, contain everything.
  end

  test "only visitor sees only things that have not been claimed" do
    @request.cookies['visitor'] = 'true'
    get :index
    assert assigns(:wishes).include?(@teapot), "teapot is unclaimed. should be shown to visitors"
    assert !assigns(:wishes).include?(@teaspoon), "teaspoon is claimed. should not be shown to visitors"

    @request.cookies['visitor'] = 'false'
    get :index
    assert assigns(:wishes).include?(@teapot), "teapot is unclaimed. should be shown to anyone"
    assert assigns(:wishes).include?(@teaspoon), "teaspoon is claimed. should be shown to owner"
end

  test "should show wish" do
    get :show, id: @teapot
    assert_response :success
    assert_equal(assigns(:wish).title, @teapot.title)
  end
end
