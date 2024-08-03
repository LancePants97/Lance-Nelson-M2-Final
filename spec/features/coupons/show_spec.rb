require "rails_helper"

RSpec.describe "merchant coupons index" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Twin Lights Brewery")

    @coupon1 = Coupon.create(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create(name: "$3 Off!", code: "3DOLLAR", value: 3, discount_type: 1, status: 1, merchant_id: @merchant2.id)

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, coupon_id: @coupon1.id)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2, coupon_id: @coupon1.id)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2, coupon_id: @coupon2.id)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2, coupon_id: @coupon2.id)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1, coupon_id: @coupon4.id)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)
  end
  describe "as a merchant, when I visit my coupon's show page" do
    it "shows the coupon's attributes and how many times it has been used" do
      visit merchant_coupon_path(@merchant1, @coupon1)

      expect(page).to have_content("Coupon Name: #{@coupon1.name}")
      expect(page).to have_content("Code: #{@coupon1.code}")
      expect(page).to have_content("Value: #{@coupon1.value}% off")
      expect(page).to have_content("This coupon has been used 3 times")
    end

    it "shows another coupon's attributes and how many times it has been used" do
      visit merchant_coupon_path(@merchant1, @coupon2)

      expect(page).to have_content("Coupon Name: #{@coupon2.name}")
      expect(page).to have_content("Code: #{@coupon2.code}")
      expect(page).to have_content("Value: #{@coupon2.value}% off")
      expect(page).to have_content("This coupon has been used 2 times")
    end

    it "shows another coupon's attributes and how many times it has been used" do
      visit merchant_coupon_path(@merchant1, @coupon3)

      expect(page).to have_content("Coupon Name: #{@coupon3.name}")
      expect(page).to have_content("Code: #{@coupon3.code}")
      expect(page).to have_content("Value: #{@coupon3.value}% off")
      expect(page).to have_content("This coupon has been used 0 times")
    end

    it "shows another coupon's attributes and how many times it has been used" do
      visit merchant_coupon_path(@merchant2, @coupon4)

      expect(page).to have_content("Coupon Name: #{@coupon4.name}")
      expect(page).to have_content("Code: #{@coupon4.code}")
      expect(page).to have_content("Value: #{@coupon4.value}% off")
      expect(page).to have_content("This coupon has been used 1 time")
    end
  end
end