require "rails_helper"

RSpec.describe "merchant coupons create" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @merchant2 = Merchant.create!(name: "Twin Lights Brewery")

    @coupon1 = Coupon.create(name: "50% Off!", code: "12345", value: 50, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "10% Off!", code: "54321", value: 10, discount_type: 0, status: 1, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "$2 Off!", code: "TWOTODAY", value: 2, discount_type: 1, status: 1, merchant_id: @merchant1.id)
    @coupon4 = Coupon.create(name: "$3 Off!", code: "3DOLLAR", value: 3, discount_type: 1, status: 1, merchant_id: @merchant2.id)
  end
  describe "as a merchant, when I visit my coupons index page" do
    it "there is a functional link to create a new coupon" do
      visit merchant_coupons_path(@merchant1)

      within("#coupons") do
        expect(page).to_not have_content("15% Off")
        expect(page).to_not have_content("Value: 15% off")
      end

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
      expect(new_coupon.status).to eq("inactive")

      within("#coupons") do
        expect(page).to have_link(new_coupon.name)
        expect(page).to have_link(new_coupon.value)
      end
    end

    it "the form will not save if you do not fill in a name" do
      visit new_merchant_coupon_path(@merchant1)

      fill_in :code, with: ("12345")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(page).to have_content("Please correctly fill in all form fields")
    end

    it "the form will not save if you enter a code that is already in use" do
      visit new_merchant_coupon_path(@merchant1)

      fill_in :name, with: ("15% Off")
      fill_in :code, with: ("12345")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(page).to have_content("Please correctly fill in all form fields")
    end

    it "the form will not save if you do not fill in a code" do
      visit new_merchant_coupon_path(@merchant1)

      fill_in :name, with: ("15% Off")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(page).to have_content("Please correctly fill in all form fields")
    end

    it "the form will not save if you use a different capitalization of an existing code" do
      visit new_merchant_coupon_path(@merchant1)

      fill_in :name, with: ("15% Off")
      fill_in :code, with: ("twotoday")
      fill_in :value, with: (15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(page).to have_content("Please correctly fill in all form fields")
    end

    it "the form will not save if you try a negative discount value" do
      visit new_merchant_coupon_path(@merchant1)

      fill_in :name, with: ("15% Off")
      fill_in :code, with: ("1950")
      fill_in :value, with: (-15)
      page.select "Percent", from: "discount_type"
      click_button "Save"

      expect(page).to have_content("Please correctly fill in all form fields")
    end
  end
end
