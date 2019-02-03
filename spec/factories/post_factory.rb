require "models/post"

FactoryBot.define do
  factory :post do
    skip_create

    transient do
      keyword { "good" }
    end

    sequence(:id) { |n| n.to_s }
    sequence(:author) { |n| "Forums User #{n}" }
    text { "This is a #{keyword} post" }
    timestamp { Time.now }
  end
end
