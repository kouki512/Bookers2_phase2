class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "User"
      @users = User.search(params[:search],params[:word])
    else
      @books = Book.search(params[:search],params[:word])
    end
  end

end
