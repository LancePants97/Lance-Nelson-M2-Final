require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
    it { should belong_to :merchant }
  end
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of(:code).case_insensitive }
    it { should validate_presence_of :value }
  end
end