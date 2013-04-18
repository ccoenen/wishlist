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
    assert_equal(@teapot.title, assigns(:wish).title)
  end

  test "visitors may enter email to claim a wish" do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      post :prepare_claim, claim: { email: "some@thing.com"}, id: @teapot
    end

    claim_mail = ActionMailer::Base.deliveries.last
    assert_equal 'some@thing.com', claim_mail.to[0]

    assert_response :redirect
  end

  test "clicking the link actually claims the wish" do
    get :claim, {email: 'some@thing.com', id: @teapot.secret}
    assert_equal @teapot, assigns(:wish), 'should find the right wish by secret'
    assert_equal 'some@thing.com', assigns(:wish).claimed_by, 'should be claimed by the right person'
  end
end
