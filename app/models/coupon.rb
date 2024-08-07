class Coupon < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  belongs_to :merchant
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true, numericality: { greater_than: 0}
  validates :discount_type, presence: true

  enum discount_type: { percentage: 0, dollar: 1 }
  enum status: { inactive: 0, active: 1 }

  def times_applied
    transactions.where("result = 1").count
  end

  def pending_transactions
    transactions.where("result = 1").count
  end

  def pending_items_count
    invoice_items.where("invoice_items.status = 0").count
  end
end