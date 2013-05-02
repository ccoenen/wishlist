class WishesController < ApplicationController
  # GET /wishes
  def index
    conditions = if cookies[:visitor] && cookies[:visitor] === 'true' # cookies actually are strings.
      logger.debug "visitors should see only available things."
      {:claimed_by => nil}
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

  # POST /wishes/1/prepare_claim
  def prepare_claim
    @wish = Wish.find(params[:id])
    ClaimMailer.claim(@wish, params[:claim][:email]).deliver
    redirect_to @wish, :notice => I18n.t('wishes_controller.prepare_claim_notice')
  end

  # GET /wishes/ae2342ac/claim
  def claim
    @wish = Wish.find_by_secret(params[:id])
    @wish.claimed_by = params[:email]
    @wish.save
    redirect_to @wish, :notice => I18n.t('wishes_controller.claim_notice', :title => @wish.title)
  end
end
