require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
    it { should_not validate_presence_of :coupon_id } # this is redundant but I'm leaving it in since the coupon_id is optional here
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should belong_to(:coupon).optional }
    it { should have_many :transactions}
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end
  before(:each) do
    @m1 = Merchant.create!(name: "Merchant 1")
    @m2 = Merchant.create!(name: "Merchant 2")

    @coupon1 = Coupon.create!(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: @m1.id)
    @coupon2 = Coupon.create!(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 0, merchant_id: @m1.id)
    @coupon3 = Coupon.create!(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: @m1.id)

    @coupon4 = Coupon.create!(name: "Half Off!", code: "Halfsies", value: 50, discount_type: 0, status: 1, merchant_id: @m2.id)
    @coupon5 = Coupon.create!(name: "$6 Off!", code: "6DOLLAR", value: 6, discount_type: 1, status: 0, merchant_id: @m2.id)
    
    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: @coupon4.id)
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09", coupon_id: @coupon3.id)
    @i3 = Invoice.create!(customer_id: @c1.id, status: 1, created_at: "2012-03-25 09:31:09")
    @i4 = Invoice.create!(customer_id: @c1.id, status: 1, created_at: "2012-03-25 09:31:09", coupon_id: @coupon3.id)

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)
    @item_3 = Item.create!(name: "best", description: "please test me", unit_price: 10, merchant_id: @m2.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 14, unit_price: 12, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_3.id, quantity: 10, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 15, unit_price: 2, status: 1)

    @ii_6 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_2.id, quantity: 10, unit_price: 2, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 5, unit_price: 5, status: 1)

    @ii_8 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_1.id, quantity: 10, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_2.id, quantity: 5, unit_price: 6, status: 1)

    @i1_subtotal = (@ii_1.unit_price * @ii_1.quantity) + (@ii_2.unit_price * @ii_2.quantity) + (@ii_4.unit_price * @ii_4.quantity)
    @i1_admin_grand_total = @i1_subtotal - (@coupon4.value * (@ii_4.unit_price * @ii_4.quantity) / 100)
    @i1_merchant_grand_total = (@coupon4.value * (@ii_4.unit_price * @ii_4.quantity) / 100)

    @i2_subtotal = (@ii_3.unit_price * @ii_3.quantity) + (@ii_5.unit_price * @ii_5.quantity)
    @i2_admin_grand_total = @i2_subtotal - @coupon3.value

    @i3_subtotal = (@ii_6.unit_price * @ii_6.quantity) + (@ii_7.unit_price * @ii_7.quantity)
    @i3_admin_grand_total = @i3_subtotal - @coupon3.value

    @i4_subtotal = (@ii_8.unit_price * @ii_8.quantity) + (@ii_9.unit_price * @ii_9.quantity)
    @i4_grand_total = @i4_subtotal - @coupon3.value
  end
  describe "instance methods" do
    it "total_revenue" do
      expect(@i1.total_revenue).to eq(@i1_subtotal)
      expect(@i2.total_revenue).to eq(@i2_subtotal)
      expect(@i3.total_revenue).to eq(@i3_subtotal)
      expect(@i4.total_revenue).to eq(@i4_subtotal)
    end

    it "grand_total" do # needs to be invoice with items from only one merchant to simulate a merchant invoice show page
      expect(@i4.grand_total).to eq(@i4_grand_total)
    end

    it "merchant_grand_total" do
      # binding.pry
      expect(@i1.merchant_grand_total).to eq(@i1_merchant_grand_total)
      expect(@i2.merchant_grand_total).to eq(@coupon3.value)
      # @i3 does not get tested because it has no coupon
      expect(@i4.merchant_grand_total).to eq(@coupon3.value)
    end

    it "admin_grand_total" do
      expect(@i1.admin_grand_total).to eq(@i1_admin_grand_total)
      expect(@i2.admin_grand_total).to eq(@i2_admin_grand_total)
      # @i3 does not get tested because it has no coupon
      expect(@i4.admin_grand_total).to eq(@i4_grand_total) # only items from one merchant on this invoice so the grand_total variable can be used here
    end

    it "has_coupon?" do
      expect(@i1.has_coupon?).to be true
      expect(@i2.has_coupon?).to be true
      expect(@i3.has_coupon?).to be false
      expect(@i4.has_coupon?).to be true
    end
  end
end
