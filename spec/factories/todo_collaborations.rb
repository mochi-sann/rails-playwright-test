FactoryBot.define do
  factory :todo_collaboration do
    association :todo
    association :user
    role { :viewer }
  end
end
