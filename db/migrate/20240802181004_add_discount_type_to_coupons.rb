class AddDiscountTypeToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :discount_type, :integer
  end
end
