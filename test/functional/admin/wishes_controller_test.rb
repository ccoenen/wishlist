require 'test_helper'

class Admin::WishesControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
	@auth = ActionController::HttpAuthentication::Basic.encode_credentials("frodo", "thering")
  end

  test "should need authentication" do
    get :index
    assert_response :unauthorized
    get :new
    assert_response :unauthorized
    get :show, id: @teapot
    assert_response :unauthorized
    get :edit, id: @teapot
    assert_response :unauthorized
    post :create
    assert_response :unauthorized
    delete :destroy, id: @teapot
    assert_response :unauthorized
    post :sort
    assert_response :unauthorized
  end

  test "should get index" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    get :index
    assert_response :success
    assert_not_nil assigns(:wishes)
  end

  test "should get new" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    get :new
    assert_response :success
  end

  test "should create admin_wish" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    assert_difference('Wish.count') do
      post :create, wish: { notes: @teapot.notes, title: @teapot.title, url: @teapot.url, image: fixture_file_upload('/files/smiley.png') }
    end

    assert_redirected_to admin_wish_path(assigns(:wish))
  end

  test "should show admin_wish" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    get :show, id: @teapot
    assert_response :success
  end

  test "should get edit" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    get :edit, id: @teapot
    assert_response :success
  end

  test "should update admin_wish" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    put :update, id: @teapot, wish: { notes: @teapot.notes, title: @teapot.title, url: @teapot.url, image: fixture_file_upload('/files/smiley.png') }
    assert_redirected_to admin_wish_path(assigns(:wish))
  end

  test "should destroy admin_wish" do
    @request.env['HTTP_AUTHORIZATION'] = @auth
    assert_difference('Wish.count', -1) do
      delete :destroy, id: @teapot
    end

    assert_redirected_to admin_wishes_path
  end

  test "sorting by jquery-ui" do
    assert_equal 3, Wish.find(wishes(:secret_sugar).id).position
    assert_equal 1, Wish.find(wishes(:taken_teaspoon).id).position
    assert_equal 2, Wish.find(wishes(:teapot).id).position
    @request.env['HTTP_AUTHORIZATION'] = @auth
    post :sort, :wish => [wishes(:secret_sugar).id, wishes(:taken_teaspoon).id, wishes(:teapot).id]
    assert_equal 1, Wish.find(wishes(:secret_sugar).id).position
    assert_equal 2, Wish.find(wishes(:taken_teaspoon).id).position
    assert_equal 3, Wish.find(wishes(:teapot).id).position
  end
end
