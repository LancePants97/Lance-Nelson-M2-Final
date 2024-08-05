require "rails_helper"

RSpec.describe "merchant coupon status update" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Twin Lights Brewery")

    @coupon1 = Coupon.create(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: @merchant1.id) # active
    @coupon2 = Coupon.create(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 1, merchant_id: @merchant1.id) # active
    @coupon3 = Coupon.create(name: "$2Off!", code: "19282", value: 2, discount_type: 1, status: 0, merchant_id: @merchant1.id) # inactive
    @coupon4 = Coupon.create(name: "VSCode Sale", code: "CODELOL", value: 15, discount_type: 0, status: 1, merchant_id: @merchant1.id) # active
    @coupon5 = Coupon.create(name: "Ruby Flash Sale", code: "RUBYDOOBIE", value: 30, discount_type: 0, status: 1, merchant_id: @merchant1.id) # active
    @coupon6 = Coupon.create(name: "$5 Off!", code: "BEGONE", value: 5, discount_type: 1, status: 1, merchant_id: @merchant1.id)# active

    @coupon7 = Coupon.create(name: "$3 Off!", code: "3DOLLAR", value: 3, discount_type: 1, status: 0, merchant_id: @merchant2.id) # active

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_2.id, status: 2, coupon_id: @coupon1.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 1, unit_price: 5, status: 0)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
  end

  it "has a functional button to deactivate the coupon" do
    visit merchant_coupon_path(@merchant1, @coupon2)

    expect(page).to have_content("Status: active")
    click_button "Deactivate"
    
    expect(current_path).to eq merchant_coupon_path(@merchant1, @coupon2)
    expect(page).to have_content("Coupon Has Been Deactivated!")
  end

  it "has a functional button to activate the coupon" do
    visit merchant_coupon_path(@merchant2, @coupon7)

    expect(page).to have_content("Status: inactive")
    click_button "Activate"
    
    expect(current_path).to eq merchant_coupon_path(@merchant2, @coupon7)
    expect(page).to have_content("Coupon Has Been Activated!")
  end

  it "has no button if the merchant already has 5 active coupons" do
    visit merchant_coupon_path(@merchant1, @coupon3)

    expect(page).to have_content("Status: inactive")

    expect(page).to have_content("Make sure you have less than 5 active coupons, and that none of those active coupons have pending invoice items.")
    expect(page).to_not have_button "Deactivate"
    expect(page).to_not have_button "Activate"
  end

  it "has no button if the coupon has any pending invoice items" do
    visit merchant_coupon_path(@merchant1, @coupon1)

    expect(page).to have_content("Status: active")

    expect(page).to have_content("Make sure you have less than 5 active coupons, and that none of those active coupons have pending invoice items.")
    expect(page).to_not have_button "Deactivate"
    expect(page).to_not have_button "Activate"
  end
end