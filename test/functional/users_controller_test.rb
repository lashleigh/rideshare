require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.first
  end
  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end
  test "should redirect" do
    get :show, :id => "abcdefg" 
    assert_redirected_to root_path 
  end

end
