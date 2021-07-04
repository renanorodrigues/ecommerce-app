FactoryBot.define do
  factory :license do
    key { Faker::Lorem.characters(number: 15) }
    status { :available }
    platform { :steam }
    game
    user
  end
end
