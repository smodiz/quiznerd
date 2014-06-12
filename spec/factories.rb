
FactoryGirl.define do


  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "something"
    password_confirmation "something"
  end

  factory :quiz do
    sequence(:name) { |n| "Quiz Number #{n}"}
    description "This is a quiz created by Factory Girl."
    category Category.first
    subject Subject.first
    published false
  end

  factory :question do
    sequence(:content) { |n| "Question number #{n}"}
    remarks "These are some remarks to show the user after they answer"
    sequence(:question_type) { |n| Question::QUESTION_TYPES.keys[n%4] }
  end

  factory :answer do
    sequence(:content) { |n| "Answer number #{n}" }
    sequence(:correct) { |n| n.even? ? true : false }
  end

end

