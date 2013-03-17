class WishesController < ApplicationController
  # GET /wishes
  def index
    conditions = if cookies[:visitor] && cookies[:visitor] === 'true' # cookies actually are strings.
      logger.debug "visitors should see only available things."
      {:taken_by => nil}
    else
      logger.debug "non-visitors (i.e. owners) should see everything to not get spoiled"
      {}
    end
    @wishes = Wish.find(:all, :conditions => conditions)
  end

  # GET /wishes/1
  def show
    @wish = Wish.find(params[:id])
  end
end
