# frozen_string_literal: true

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  include NameSearchable
  include Paginatable
  has_many :licenses, dependent: :restrict_with_error
  
  validates :name, :profile, presence: true

  enum profile: { admin: 0, client: 1 }
end
