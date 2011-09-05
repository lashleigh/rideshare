require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should create a session" do
    post :create
    assert_redirected_to root_url
  end

  test "should show trip" do
    get :show, :id => @trip.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @trip.to_param
    assert_response :success
  end

  test "should update trip" do
    put :update, :id => @trip.to_param, :trip => @trip.attributes
    assert_redirected_to trip_path(assigns(:trip))
  end

  test "should destroy trip" do
    assert_difference('Trip.count', -1) do
      delete :destroy, :id => @trip.to_param
    end

    assert_redirected_to trips_path
  end

end
