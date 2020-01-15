class Coupon < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :code, uniqueness: true, presence: true

  validates_presence_of :percentage

  belongs_to :merchant
  has_many :orders

  # def discount
  #   (100-self.percentage)/100
  # end
end
