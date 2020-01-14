class Coupon < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true

  validates_presence_of :percentage

  has_many :orders
  belongs_to :merchant
end
