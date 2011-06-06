require 'test_helper'

class GiveawaysControllerTest < ActionController::TestCase
  setup do
    @giveaway = giveaways(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:giveaways)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create giveaway" do
    assert_difference('Giveaway.count') do
      post :create, :giveaway => @giveaway.attributes
    end

    assert_redirected_to giveaway_path(assigns(:giveaway))
  end

  test "should show giveaway" do
    get :show, :id => @giveaway.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @giveaway.to_param
    assert_response :success
  end

  test "should update giveaway" do
    put :update, :id => @giveaway.to_param, :giveaway => @giveaway.attributes
    assert_redirected_to giveaway_path(assigns(:giveaway))
  end

  test "should destroy giveaway" do
    assert_difference('Giveaway.count', -1) do
      delete :destroy, :id => @giveaway.to_param
    end

    assert_redirected_to giveaways_path
  end
end
