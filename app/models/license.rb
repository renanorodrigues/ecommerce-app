class License < ApplicationRecord
  include LikeSearchable
  include Paginatable

  belongs_to :game
  belongs_to :user

  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }
  validates :status, :platform, presence: true

  enum status: { available: 1, in_use: 2, inactive: 3 }
  enum platform: { steam: 1, battle_net: 2, origin: 3 }
end
