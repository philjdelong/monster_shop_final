class CouponsController < ApplicationController

  def update
    coupon = Coupon.where(code: params[:coupon_code])[0]
    session[:current_coupon] = coupon
    flash[:success] = "#{coupon.name} has been applied!"
    redirect_to '/cart'
  end
end
