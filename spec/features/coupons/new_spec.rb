require "rails_helper"

RSpec.describe "merchant coupons create" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Twin Lights Brewery")

    @coupon1 = Coupon.create(name: "50% Off!", code: "12345", value: 50, discount_type: 0, active: true, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "10% Off!", code: "54321", value: 10, discount_type: 0, active: true, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, active: true, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create(name: "$3 Off!", code: "3DOLLAR", value: 3, discount_type: 1, active: true, merchant_id: @merchant2.id)
  end
  describe "as a merchant, when I visit my coupons index page" do
    it "there is a functional link to create a new coupon" do
      visit merchant_coupons_path(@merchant1)

      click_link "New Coupon"

      expect(current_path).to eq new_merchant_coupon_path(@merchant1)

      fill_in :name, with: ("15% Off")
      fill_in :code, with: ("FIFTEEN")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(current_path).to eq merchant_coupons_path(@merchant1)

      expect(page).to have_content("Coupon was successfully created!")

      new_coupon = Coupon.last

      within("#coupons") do
        expect(page).to have_link(new_coupon.name)
        expect(page).to have_link(new_coupon.value)
      end
    end

    it "the form will not save unless all fields are correctly filled in" do
      visit merchant_coupons_path(@merchant1)

      click_link "New Coupon"

      expect(current_path).to eq new_merchant_coupon_path(@merchant1)
      # save_and_open_page
      fill_in :name, with: ("15% Off")
      fill_in :code, with: ("12345")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(current_path).to eq merchant_coupons_path(@merchant1)
      save_and_open_page
      expect(page).to have_content("Please correctly fill in all form fields")
    end
  end
end
