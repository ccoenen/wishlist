require 'test_helper'

class WishesControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
    @teaspoon = wishes(:taken_teaspoon)
    @sugar = wishes(:secret_sugar)
  end

  test "should get owner-protection-page" do
    get :owner_protection
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

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wishes)
    assert assigns(:wishes).include?(@teapot)
    assert assigns(:wishes).include?(@teaspoon) # when in doubt, contain everything.
    assert !assigns(:wishes).include?(@sugar), "don't ever contain unpublished items"
  end

  test "owner won't see what's claimed" do
    @request.cookies['visitor'] = 'true'
    get :index
    assert assigns(:wishes).include?(@teapot), "teapot is unclaimed. should be shown to visitors"
    assert assigns(:wishes).include?(@teaspoon), "teaspoon is claimed. be on the list"
    assert @teaspoon.claimed_by, "Teaspoon should display as claimed to visitors"
    assert !assigns(:wishes).include?(@sugar), "don't ever contain unpublished items"
    assigns(:wishes).each do |wish|
      assert !wish.frozen?
    end
    assert_equal 0, assigns(:wishes).index(@teapot), "visitors see the teapot up top"
    assert_equal 1, assigns(:wishes).index(@teaspoon), "visitors see the teaspoon second, it's already taken."

    @request.cookies['visitor'] = 'false'
    get :index
    assert assigns(:wishes).include?(@teapot), "teapot is unclaimed. should be shown to anyone"
    assert assigns(:wishes).include?(@teaspoon), "teaspoon is claimed. should be shown to owner"
    assert !assigns(:wishes).include?(@sugar), "don't ever contain unpublished items"
    assigns(:wishes).each do |wish|
      assert wish.readonly?, "all items should be read only for owners"
      assert_nil wish.claimed_by, "no item should appear claimed to owners - even if it is"
    end
    assert_equal 1, assigns(:wishes).index(@teapot), "owner sees the list sorted by position only"
    assert_equal 0, assigns(:wishes).index(@teaspoon), "owner sees the list sorted by position only"
  end

  test "should show wish" do
    get :show, id: @teapot
    assert_response :success
    assert_equal(@teapot.title, assigns(:wish).title)
  end

  test "should not show unpublished wish" do
    get :show, id: @sugar
    assert_nil(assigns(:wish))
    assert_redirected_to root_url
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
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      get :claim, {email: 'some@thing.com', id: @teapot.secret}
    end
    assert_equal @teapot, assigns(:wish), 'should find the right wish by secret'
    assert_equal 'some@thing.com', assigns(:wish).claimed_by, 'should be claimed by the right person'
    assert_equal I18n.t('wishes_controller.claim_notice', :title => @teapot.title), flash[:notice], "right flash for success is displayed"
  end

  test "reclaiming a claimed wish will give you a notice" do
    assert_difference 'ActionMailer::Base.deliveries.size', 0 do
      get :claim, {email: 'some@thing.com', id: @teaspoon.secret}
    end
    assert_equal @teaspoon, assigns(:wish), 'should find the right wish by secret'
    assert_not_equal 'some@thing.com', assigns(:wish).claimed_by, 'should be claimed by the original person'
    assert_equal I18n.t('wishes_controller.claim_failed_notice', {:title => @teaspoon.title, :email => @teaspoon.claimed_by}), flash[:notice], "right flash for failure is displayed"
  end
end
