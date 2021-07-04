class Product < ApplicationRecord
  include LikeSearchable
  include Paginatable
  
  belongs_to :productable, polymorphic: true
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories

  validates :description, :image, :status, presence: :true
  validates :name, presence: :true, uniqueness: { case_sensitive: false }
  validates :price, presence: :true, numericality: { greater_than: 0 }

  has_one_attached :image

  enum status: { available: 1, unavailable: 2 }
end
