if Rails.env.development? || Rails.env.test?
  require 'factory_bot'

  namespace :dev do
    desc 'Data for local development env'
    task prime: 'db:setup' do
      include FactoryBot::Syntax::Methods

      15.times do
        profile = %i(admin client).sample
        create(:user, profile: profile)
      end

      system_requirements = []
      %w(Basic Intermediate Advanced).each do |level_requirement|
        system_requirements << create(:system_requirement, name: level_requirement)
      end

      15.times do
        coupon_status = %i(active inactive).sample
        create(:coupon, status: coupon_status)
      end

      categories = []
      25.times { categories << create(:category, name: Faker::Game.unique.genre) }

      30.times do
        game_name = Faker::Game.unique.title
        availability = %i(available unavailable).sample
        categories_count = rand(0..3)
        game_categories_id = []
        categories_count.times { game_categories_id << Category.all.sample.id }
        game = create(:game, system_requirement: system_requirements.sample)
        create(:product, name: game_name, status: availability, 
                         category_ids: game_categories_id, productable: game)
      end

      50.times do
        game = Game.all[0..5].sample
        status = %i(available in_use inactive).sample
        platform = %i(steam battle_net origin).sample
        create(:license, status: status, game: game, platform: platform)
      end
    end
  end
end
