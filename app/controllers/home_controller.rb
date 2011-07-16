class HomeController < ApplicationController
  def index
  end

  def show
    @origin = params[:origin]
    @destination = params[:destination]
  end
end
