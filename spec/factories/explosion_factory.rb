require "contests/minefield/explosion"

FactoryBot.define do
  factory :explosion, class: Contests::Minefield::Explosion do
    initialize_with { new(attributes) }

    sequence(:id, &:to_s)

    association :post

    trait :sixer do
      association :post, keyword: EnvironmentVariableHelper::SIXERS.sample
    end

    trait :seven_day do
      association :post, keyword: EnvironmentVariableHelper::SEVEN_DAYS.sample
    end

    trait :cash_prize do
      association :post, keyword: EnvironmentVariableHelper::CASH_PRIZES.sample
    end

    trait :title do
      association :post, keyword: EnvironmentVariableHelper::TITLES.sample
    end
  end
end
