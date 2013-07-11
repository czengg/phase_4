require 'test_helper'

class DogosControllerTest < ActionController::TestCase
  setup do
    @dogo = dogos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dogos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dogo" do
    assert_difference('Dogo.count') do
      post :create, dogo: { active: @dogo.active, city: @dogo.city, latitude: @dogo.latitude, longitude: @dogo.longitude, name: @dogo.name, state: @dogo.state, street: @dogo.street, zip: @dogo.zip }
    end

    assert_redirected_to dogo_path(assigns(:dogo))
  end

  test "should show dogo" do
    get :show, id: @dogo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dogo
    assert_response :success
  end

  test "should update dogo" do
    put :update, id: @dogo, dogo: { active: @dogo.active, city: @dogo.city, latitude: @dogo.latitude, longitude: @dogo.longitude, name: @dogo.name, state: @dogo.state, street: @dogo.street, zip: @dogo.zip }
    assert_redirected_to dogo_path(assigns(:dogo))
  end

  test "should destroy dogo" do
    assert_difference('Dogo.count', -1) do
      delete :destroy, id: @dogo
    end

    assert_redirected_to dogos_path
  end
end
