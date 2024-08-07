class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  belongs_to :coupon, optional: true
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  # US 7
  def grand_total # after coupon is applied
    if coupon.discount_type == "percentage" && coupon.status == "active"
      ((total_revenue * coupon.value) / 100)
    elsif coupon.discount_type == "dollar" && coupon.status == "active" && total_revenue < coupon.value
      return 0
    elsif coupon.discount_type == "dollar" && coupon.status == "active" && total_revenue >= coupon.value
      total_revenue - coupon.value
    else
      puts "Coupon must be activated to use"
    end
  end

  # US 8
  def merchant_grand_total # applies invoice's coupon only to items that belong to the coupon's merchant
    merchant_invoice_items = invoice_items.joins(:item)
                                          .where(items: { merchant_id: coupon.merchant.id })
    total_before_coupon = merchant_invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')

    if coupon.discount_type == "percentage" && coupon.status == "active"
      ((total_before_coupon * coupon.value) / 100)
    elsif coupon.discount_type == "dollar" && coupon.status == "active" && total_revenue < coupon.value
      return 0
    elsif coupon.discount_type == "dollar" && coupon.status == "active" && total_revenue >= coupon.value
      total_revenue - coupon.value
    else
      puts "Coupon must be activated to use"
    end
  end

  def admin_grand_total # returns admin show page total revenue after applying coupon to one merchant's items
    total_revenue - merchant_grand_total
  end
end