require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")
    @m2 = Merchant.create!(name: "Merchant 2")

    @coupon1 = Coupon.create!(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: @m1.id)
    @coupon2 = Coupon.create!(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 0, merchant_id: @m1.id)
    @coupon3 = Coupon.create!(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: @m1.id)

    @coupon4 = Coupon.create!(name: "Half Off!", code: "Halfsies", value: 50, discount_type: 0, status: 1, merchant_id: @m2.id)
    @coupon5 = Coupon.create!(name: "$10 Off!", code: "10DOLLAR", value: 10, discount_type: 1, status: 1, merchant_id: @m2.id)
    
    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09", coupon_id: @coupon4.id)
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09", coupon_id: @coupon3.id)
    @i3 = Invoice.create!(customer_id: @c1.id, status: 1, created_at: "2012-03-25 09:31:09")
    @i4 = Invoice.create!(customer_id: @c1.id, status: 1, created_at: "2012-03-25 09:31:09", coupon_id: @coupon2.id)
    @i5 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:31:09", coupon_id: @coupon5.id)

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
    
    @ii_8 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    @ii_9 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_3.id, quantity: 1, unit_price: 2, status: 1)
  end

  it "should display the id, status and created_at" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it "should display the total revenue the invoice will generate" do
    visit admin_invoice_path(@i1)
    expect(page).to have_content("Subtotal Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    visit admin_invoice_path(@i1)
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

  # test with percentage discount type
  it "should properly display subtotal and grand total revenues of all merchants on an invoice" do
    visit admin_invoice_path(@i1)
    i1_subtotal = (@ii_1.unit_price * @ii_1.quantity) + (@ii_2.unit_price * @ii_2.quantity) + (@ii_4.unit_price * @ii_4.quantity)
    i1_grand_total = i1_subtotal - (@coupon4.value * (@ii_4.unit_price * @ii_4.quantity) / 100)

    expect(page).to have_content("Subtotal Revenue: $#{i1_subtotal}")
    expect(page).to have_content("Revenue After Coupon: $#{i1_grand_total}")
    expect(page).to have_content("Coupon Used: #{@coupon4.name}")
    expect(page).to have_content("Coupon Code: #{@coupon4.code}")

    click_link(@coupon4.name)

    expect(current_path).to eq merchant_coupon_path(@m2, @coupon4)
  end

  # test with dollar discount type
  it "should properly display subtotal and grand total revenues of all merchants on an invoice" do
    visit admin_invoice_path(@i2)
    i2_subtotal = (@ii_3.unit_price * @ii_3.quantity) + (@ii_5.unit_price * @ii_5.quantity)
    i2_grand_total = i2_subtotal - @coupon3.value

    expect(page).to have_content("Subtotal Revenue: $#{i2_subtotal}")
    expect(page).to have_content("Revenue After Coupon: $#{i2_grand_total}")
    expect(page).to have_content("Coupon Used: #{@coupon3.name}")
    expect(page).to have_content("Coupon Code: #{@coupon3.code}")

    click_link(@coupon3.name)

    expect(current_path).to eq merchant_coupon_path(@m1, @coupon3)
  end

  # test with no coupon
  it "should properly display subtotal and grand total revenues of all merchants on an invoice" do
    visit admin_invoice_path(@i3)
    i3_subtotal = (@ii_6.unit_price * @ii_6.quantity) + (@ii_7.unit_price * @ii_7.quantity)

    expect(page).to have_content("Subtotal Revenue: $#{i3_subtotal}")
    expect(page).to have_content("(No coupons used on this invoice)")
  
    expect(page).to_not have_link(@coupon4.name)
  end

  it "displays a message if the coupon is inactive" do
    visit admin_invoice_path(@i4)
    expect(page).to have_content("Coupon Inactive - discount not applied.")
  end

  it "revenue after coupon is 0 if coupon value is greater than subtotal" do
    visit admin_invoice_path(@i5)

    i5_subtotal = (@ii_8.unit_price * @ii_8.quantity) + (@ii_9.unit_price * @ii_9.quantity)

    expect(page).to have_content("Subtotal Revenue: $#{i5_subtotal}")
    expect(page).to have_content("Revenue After Coupon: $0.00")
    expect(page).to have_content("Coupon Used: #{@coupon5.name}")
    expect(page).to have_content("Coupon Code: #{@coupon5.code}")

    click_link(@coupon5.name)

    expect(current_path).to eq merchant_coupon_path(@m2, @coupon5)
  end
end
