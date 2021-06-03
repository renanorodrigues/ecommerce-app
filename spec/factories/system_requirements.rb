FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "SystemRequirement #{n}" }
    operational_system { Faker::Computer.os }
    storage { "120GB" }
    processor { "Intel 3" }
    memory { "4GB" }
    video_board { "GeoForce" }
  end
end
