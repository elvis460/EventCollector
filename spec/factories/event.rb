FactoryBot.define do
  factory :event do
    held_at { Date.today.beginning_of_day }
    title { Faker::Movie.quote }
    img_url { Faker::Internet.url }
    link { Faker::Internet.url }
    extract_from { Event::VALID_EXTRACT_SOURCE.sample }
  end
end
