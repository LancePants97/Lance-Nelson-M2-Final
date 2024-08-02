class Coupon < ApplicationRecord
  has_many :invoices
  belongs_to :merchant

  validates :name, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :value, presence: true

  enum discount_type: { percentage: 0, dollar: 1 }
end