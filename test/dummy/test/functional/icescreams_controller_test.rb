require 'test_helper'

class IcescreamsControllerTest < ActionController::TestCase
  setup do
    @icescream = icescreams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:icescreams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create icescream" do
    assert_difference('Icescream.count') do
      post :create, icescream: { deliciousness: @icescream.deliciousness, flavor: @icescream.flavor }
    end

    assert_redirected_to icescream_path(assigns(:icescream))
  end

  test "should show icescream" do
    get :show, id: @icescream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @icescream
    assert_response :success
  end

  test "should update icescream" do
    put :update, id: @icescream, icescream: { deliciousness: @icescream.deliciousness, flavor: @icescream.flavor }
    assert_redirected_to icescream_path(assigns(:icescream))
  end

  test "should destroy icescream" do
    assert_difference('Icescream.count', -1) do
      delete :destroy, id: @icescream
    end

    assert_redirected_to icescreams_path
  end
end
