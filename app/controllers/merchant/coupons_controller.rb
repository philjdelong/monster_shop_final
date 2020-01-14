class Merchant::CouponsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
  end

  def new
  end

  def create
    merchant = current_user.merchant
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save
      flash[:success] = "Coupon Created!"
      redirect_to '/merchant/coupons'
    else
      flash[:error] = "Please enter valid coupon info."
      redirect_to '/merchant/coupons/new'
    end
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    coupon = Coupon.find(params[:id])
    if coupon.update(coupon_params)
      flash[:success] = "Coupon Updated!"
      redirect_to "/merchant/coupons/#{coupon.id}"
    else
      flash[:error] = "Please enter valid coupon info."
      redirect_to "/merchant/coupons/#{coupon.id}/edit"
    end
  end

  private

  def coupon_params
    params.permit(:name, :code, :percentage)
  end
end
