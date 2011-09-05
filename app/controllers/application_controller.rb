class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :current_user

  private

  def require_user
    unless current_user
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
