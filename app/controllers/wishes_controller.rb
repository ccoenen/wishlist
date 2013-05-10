class WishesController < ApplicationController

  def owner_protection
  end

  def owner
    cookies[:visitor] = false
    redirect_to wishes_url
  end

  def visitor
    cookies[:visitor] = true
    redirect_to wishes_url
  end


  # GET /wishes
  def index
    conditions = if cookies[:visitor] && cookies[:visitor] === 'true' # cookies actually are strings.
      logger.debug "visitors should see only available things."
      {:public => true, :claimed_by => nil}
    else
      logger.debug "non-visitors (i.e. owners) should see everything to not get spoiled"
      {:public => true}
    end
    @wishes = Wish.find(:all, :conditions => conditions)
  end

  # GET /wishes/1
  def show
    begin
      @wish = Wish.find(params[:id], :conditions => {:public => true})
    rescue ActiveRecord::RecordNotFound => e
      logger.warn e
      redirect_to root_url, :notice => I18n.t('wishes_controller.wish_not_found')
    end
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
