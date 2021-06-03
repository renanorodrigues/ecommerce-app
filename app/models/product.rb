class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  validates :description, presence: :true
  validates :name, presence: :true, uniqueness: { case_sensitive: false }
  validates :price, presence: :true, numericality: { greater_than: 0 }
end
