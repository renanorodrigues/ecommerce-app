FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Coupon #{n}" }
    code { Faker::Commerce.unique.promotion_code(digits: 4) }
    status { :active }
    discount_value { 25 }
    max_use { 1 }
    due_data { 3.days.from_now }
  end
end
