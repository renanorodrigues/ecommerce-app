class SystemRequirement < ApplicationRecord
  include NameSearchable
  include Paginatable
  has_many :games, dependent: :restrict_with_error
  validates :name, :storage, :processor, :memory, :video_board, :operational_system, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
