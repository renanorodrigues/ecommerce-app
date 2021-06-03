class SystemRequirement < ApplicationRecord
  validates :name, :storage, :processor, :memory, :video_board, :operational_system, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
