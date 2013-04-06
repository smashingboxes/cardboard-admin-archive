require 'test_helper'

class PianosControllerTest < ActionController::TestCase
  setup do
    @piano = pianos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pianos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create piano" do
    assert_difference('Piano.count') do
      post :create, piano: { image: @piano.image, name: @piano.name }
    end

    assert_redirected_to piano_path(assigns(:piano))
  end

  test "should show piano" do
    get :show, id: @piano
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @piano
    assert_response :success
  end

  test "should update piano" do
    put :update, id: @piano, piano: { image: @piano.image, name: @piano.name }
    assert_redirected_to piano_path(assigns(:piano))
  end

  test "should destroy piano" do
    assert_difference('Piano.count', -1) do
      delete :destroy, id: @piano
    end

    assert_redirected_to pianos_path
  end
end
