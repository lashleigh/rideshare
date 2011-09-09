require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  setup do
    Trip.destroy_all
    @unsaved_trip = FactoryGirl.build(:future_trip)
    @trip = FactoryGirl.build(:future_trip)
    @user = User.find("4e6452228c4f2587b6000005") #FactoryGirl.create(:user)
    @trip.user = @user
    @trip.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trips)
  end

  test "should get new" do
    get(:new, nil, {:user_id => @user.id})
    assert_response :success
  end
  test "should not get new" do
    get :new
    assert_redirected_to root_path
  end

  test "should create trip" do
    assert_difference('Trip.count') do
      post(:create, {:trip => @unsaved_trip.attributes}, {:user_id => @user.id})
    end

    assert_redirected_to trip_path(assigns(:trip))
  end

  test "should not create trip" do
    assert_no_difference('Trip.count') do
      post :create, :trip => @trip.attributes
    end

    assert_redirected_to root_path 
  end

  test "should show trip" do
    get :show, :id => @trip.to_param
    assert_response :success
  end

  test "should get edit" do
    get(:edit, {:id => @trip.to_param}, {:user_id => @user.id})
    assert_response :success
  end
  test "should not get edit" do
    get :edit, :id => @trip.to_param
    assert_redirected_to root_path 
  end

  test "should update trip" do
    put(:update, {:id => @trip.to_param, :trip => @trip.attributes}, {:user_id => @trip.user.id})
    assert_redirected_to trip_path(assigns(:trip))
  end
  test "should not update trip" do
    put :update, :id => @trip.to_param, :trip => @trip.attributes
    assert_redirected_to root_path 
  end

  test "should destroy trip" do
    assert_difference('Trip.count', -1) do
      delete(:destroy, {:id => @trip.to_param}, {:user_id => @user.id})
    end

    assert_redirected_to trips_path
  end
  test "should not destroy trip" do
    assert_no_difference('Trip.count') do
      delete :destroy, :id => @trip.to_param
    end

    assert_redirected_to root_path 
  end
end
