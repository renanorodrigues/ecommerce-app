class Coupon < ApplicationRecord
  validates :name, :code, :due_data, :status, :discount_value, :max_use, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :discount_value, numericality: { greater_than: 0 }
  validates :max_use, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  enum status: { active: 0, inactive: 1 }
end
