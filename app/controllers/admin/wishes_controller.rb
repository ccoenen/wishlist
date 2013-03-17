class Admin::WishesController < ApplicationController
  # GET /admin/wishlist
  def index
    @wishes = Wish.all
  end

  # GET /admin/wishlists/1
  def show
    @wish = Wish.find(params[:id])
  end

  # GET /admin/wishlists/new
  def new
    @wish = Wish.new
  end

  # GET /admin/wishlists/1/edit
  def edit
    @wish = Wish.find(params[:id])
  end

  # POST /admin/wishlists
  def create
    @wish = Wish.new(params[:wish])

    if @wish.save
      redirect_to admin_wish_url(@wish), notice: 'Wishlist was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /admin/wishlists/1
  def update
    @wish = Wish.find(params[:id])

    if @wish.update_attributes(params[:wish])
      redirect_to admin_wish_url(@wish), notice: 'Wishlist was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /admin/wishlists/1
  def destroy
    @wish = Wish.find(params[:id])
    @wish.destroy
    redirect_to admin_wishes_url
  end
end
