class SearchController < ApplicationController
  def new
    @search = Search.new(params) 
    @search.valid?
  end
end
