class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      if @user
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      else
        format.html {redirect_to root_url, :notice => 'User could not be found'} # show.html.erb
      end
    end
  end
end
