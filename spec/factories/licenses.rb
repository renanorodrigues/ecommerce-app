FactoryBot.define do
  factory :license do
    sequence(:key) { |k| "License #{k}" }
    game
    user
  end
end
