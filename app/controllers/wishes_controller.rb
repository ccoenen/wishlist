class WishesController < ApplicationController
  # GET /wishes
  def index
    @wishes = Wish.all
  end

  # GET /wishes/1
  def show
    @wish = Wish.find(params[:id])
  end
end
