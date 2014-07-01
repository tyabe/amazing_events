FactoryGirl.define do
  factory :ticket do
    user
    event
    sequence(:comment) { |i| "コメント#{i}" }

    factory :invalid_ticket do
      comment { 'a' * 100 }
    end
  end
end
