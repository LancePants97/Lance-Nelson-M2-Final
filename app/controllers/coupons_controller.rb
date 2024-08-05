class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @active_coupons = @merchant.active_coupons
    @inactive_coupons = @merchant.inactive_coupons
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.new(name: params[:name], 
                            code: params[:code], 
                            value: params[:value],
                            discount_type: params[:discount_type],
                            merchant: @merchant)
    if @coupon.save
      redirect_to merchant_coupons_path(@merchant), notice: 'Coupon was successfully created!'
    else
      flash[:notice] = 'Please correctly fill in all form fields'
      render :new
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    coupon = merchant.coupons.find(params[:id])
    if merchant.active_coupons_count > 5
      flash.notice = "Maximum Amount of Activated Coupons (5). Please deactivate at least one coupon in order to activate this coupon."
    elsif coupon.status == "active" && coupon.pending_items_count == 0
      coupon.update(coupon_status_params)
      flash.notice = "Coupon Has Been Deactivated!"
    elsif coupon.status == "inactive" && merchant.active_coupons_count < 5
      coupon.update(coupon_status_params)
      flash.notice = "Coupon Has Been Activated!"
    end
    redirect_to merchant_coupon_path(merchant, coupon)
  end

  private
  def coupon_status_params
    params.permit(:status)
  end
end