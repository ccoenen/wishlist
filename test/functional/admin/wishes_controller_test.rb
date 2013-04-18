require 'test_helper'

class Admin::WishesControllerTest < ActionController::TestCase
  setup do
    @teapot = wishes(:teapot)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wishes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_wish" do
    assert_difference('Wish.count') do
      post :create, wish: { notes: @teapot.notes, title: @teapot.title, url: @teapot.url }
    end

    assert_redirected_to admin_wish_path(assigns(:wish))
  end

  test "should show admin_wish" do
    get :show, id: @teapot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @teapot
    assert_response :success
  end

  test "should update admin_wish" do
    put :update, id: @teapot, wish: { notes: @teapot.notes, title: @teapot.title, url: @teapot.url }
    assert_redirected_to admin_wish_path(assigns(:wish))
  end

  test "should destroy admin_wish" do
    assert_difference('Wish.count', -1) do
      delete :destroy, id: @teapot
    end

    assert_redirected_to admin_wishes_path
  end
end
