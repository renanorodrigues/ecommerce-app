class Product < ApplicationRecord
  belongs_to :productable, polymorphic: true
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  validates :description, presence: :true
  validates :name, presence: :true, uniqueness: { case_sensitive: false }
  validates :price, presence: :true, numericality: { greater_than: 0 }
end
