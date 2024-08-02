class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @coupons = @merchant.coupons
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = Coupon.create!(name: params[:name], 
                            code: params[:code], 
                            value: params[:value],
                            discount_type: params[:discount_type],
                            merchant: @merchant)
    if @coupon.save
      redirect_to merchant_coupons_path(@merchant), notice: 'Coupon was successfully created!'
    else
      render :new, notice: 'Please correctly fill in all form fields'
    end
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @coupon = @merchant.coupons.find(params[:id])
  end
end