require 'rails_helper'

RSpec.describe License, type: :model do
  subject { build(:license) }

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :game }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  end
end
