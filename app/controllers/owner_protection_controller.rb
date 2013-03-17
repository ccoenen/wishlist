class OwnerProtectionController < ApplicationController
  def index
  end

  def owner
    cookies[:visitor] = false
    redirect_to wishes_url
  end

  def visitor
    cookies[:visitor] = true
    redirect_to wishes_url
  end
end
