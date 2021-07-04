require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:product_categories).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:product_categories) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'concerns' do
    it_behaves_like 'like searchable concern', :category, :name
    it_behaves_like 'paginatable concern', :category
  end
end
