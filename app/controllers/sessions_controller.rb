class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_authorization(auth["provider"], auth["uid"]).first || User.create_with_omniauth(auth)
    session[:access_token] = auth["credentials"]["token"]
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  def failure
    raise request.env["omniauth.auth"].to_yaml  
  end

end
