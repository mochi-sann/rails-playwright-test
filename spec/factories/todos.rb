FactoryBot.define do
  factory :todo do
    association :user
    sequence(:title) { |n| "Todo #{n}" }
    description { "Todo description" }
    completed { false }
    due_date { Date.current + 1.day }
    priority { :medium }

    transient do
      tags_list { nil }
    end

    after(:build) do |todo, evaluator|
      next if evaluator.tags_list.blank?

      todo.tag_list = evaluator.tags_list
    end

    trait :completed do
      completed { true }
    end

    trait :due_today do
      due_date { Date.current }
    end
  end
end
