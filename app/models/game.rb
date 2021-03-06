class Game < ApplicationRecord
  belongs_to :system_requirement
  has_one :product, as: :productable
  has_many :licenses, dependent: :restrict_with_error
  
  validates :mode, :developer, :release_date, presence: true

  enum mode: { pvp: 1, pve: 2, both: 3 }
end
