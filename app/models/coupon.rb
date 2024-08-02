class Coupon < ApplicationRecord
  has_many :invoices
  belongs_to :merchant

  validates :code, uniqueness: { case_sensitive: false }
end