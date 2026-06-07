FactoryBot.define do
  factory :photo do
    association :user
    sequence(:title) { |n| "写真タイトル#{n}" }

    trait :with_image do
      after(:build) do |photo|
        photo.image.attach(
          io:           File.open(Rails.root.join("spec/fixtures/files/test_image.jpg")),
          filename:     "test_image.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
