FactoryBot.define do
  factory :photo do
    association :user
    sequence(:title) { |n| "写真タイトル#{n}" }
  end
end
