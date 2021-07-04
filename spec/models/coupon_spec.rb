require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:max_use) }
    it { is_expected.to validate_numericality_of(:max_use).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:discount_value) }
    it { is_expected.to validate_numericality_of(:discount_value).is_greater_than(0) }
    it { is_expected.to define_enum_for(:status).with_values(active: 0, inactive: 1) }
    it { is_expected.to validate_presence_of(:due_data) }

    it 'cant\'t have past due_data' do
      subject.due_data = 1.day.ago
      subject.valid?
      expect(subject.errors.attribute_names).to include :due_data
    end

    it 'is invalid with current due_data' do
      subject.due_data = Time.zone.now
      subject.valid?
      expect(subject.errors.attribute_names).to include :due_data
    end

    it 'is valid with future date' do
      subject.due_data = Time.zone.now + 1.hour
      subject.valid?
      expect(subject.errors.attribute_names).to_not include :due_data
    end
  end

  context 'concerns' do
    it_behaves_like 'paginatable concern', :coupon
    it_behaves_like 'like searchable concern', :coupon, :name
  end
end
