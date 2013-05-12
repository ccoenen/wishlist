class Admin::WishesController < ApplicationController
  # taken from railscast 270 :D You obviously want to change it
  http_basic_authenticate_with :name => "frodo", :password => "thering", :realm => I18n.t('admin_wishes_controller.http_basic_auth_realm')

  layout "admin"

  # GET /admin/wishes
  def index
    @wishes = Wish.order('wishes.position ASC')
  end

  # GET /admin/wishes/1
  def show
    @wish = Wish.find(params[:id])
  end

  # GET /admin/wishes/new
  def new
    @wish = Wish.new
  end

  # GET /admin/wishes/1/edit
  def edit
    @wish = Wish.find(params[:id])
  end

  # POST /admin/wishes
  def create
    @wish = Wish.new(params[:wish])

    if @wish.save
      redirect_to admin_wish_url(@wish), notice: I18n.t('admin_wishes_controller.wish_created_notice')
    else
      render action: "new"
    end
  end

  # PUT /admin/wishes/1
  def update
    @wish = Wish.find(params[:id])

    if @wish.update_attributes(params[:wish])
      redirect_to admin_wish_url(@wish), notice: I18n.t('admin_wishes_controller.wish_updated_notice')
    else
      render action: "edit"
    end
  end

  # DELETE /admin/wishes/1
  def destroy
    @wish = Wish.find(params[:id])
    @wish.destroy
    redirect_to admin_wishes_url
  end

  # POST /admin/wishes/sort
  def sort
    @wishes = Wish.all
    @wishes.each do |w|
      w.position = params[:wish].index(w.id.to_s) + 1
      w.save
    end

    render :nothing => true
  end
end
