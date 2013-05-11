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
    @wishes = Wish.find(:all, :conditions => {:public => true})
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
    if @wish.claimed_by.nil?
      @wish.claimed_by = params[:email]
      @wish.save
      ClaimMailer.claimed_successfully(@wish, params[:email]).deliver
      notice = I18n.t('wishes_controller.claim_notice', :title => @wish.title)
    else
    notice = I18n.t('wishes_controller.claim_failed_notice', {:title => @wish.title, :email => @wish.claimed_by})
    end
    redirect_to @wish, :notice => notice
  end
end
