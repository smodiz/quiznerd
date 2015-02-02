
FactoryGirl.define do


  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "something"
    password_confirmation "something"
  end


  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :subject do
    sequence(:name) { |n| "Subject #{n}" } 
    association :category, factory: :category
  end

  factory :quiz do 
    sequence(:name) { |n| "Quiz Number #{n}"}
    description "This is a quiz created by Factory Girl."
    published true
    association :author, factory: :user
    association :category, factory: :category
    association :subject, factory: :subject
    factory :quiz_with_questions do |qz|
      qz.questions { |questions| [questions.association(:question),questions.association(:question)] }
    end
    factory :small_quiz do |qz|
      qz.questions { |questions| [questions.association(:question),questions.association(:question)] }
    end    
  end

  factory :question do 
    sequence(:content) { |n| "WhyWhyWhy! #{n}" }
    question_type "MC-2"
    remarks "remarks for question"
    answers { |answers| [answers.association(:answer_correct), answers.association(:answer_incorrect)] }
  end

  factory :answer do
    sequence(:content) { |n| "Answer number #{n}" }
    sequence(:correct) { true }
    factory :answer_incorrect do
      correct false
    end
    factory :answer_correct do
      correct true
    end
  end

  factory :quiz_event do
      status "In Progress"
      total_correct 0
      total_answered 0
      association :user, factory: :user
      association :quiz, factory: :quiz_with_questions
      factory :small_quiz_event do
        association :quiz, factory: :small_quiz
      end
  end

  factory :cheatsheet do
    sequence(:title) { |n| "Cheatsheet #{n} - Test" }
    content "sample content"
    status_id 1
    association :user, factory: :user
  end

end

  