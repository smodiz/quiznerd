
FactoryGirl.define do


  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "something"
    password_confirmation "something"
  end


  factory :category do
    name "Category FactoryGirl Testing"
  end

  factory :subject do
     name "Subject FactoryGirl Testing"
  end

  factory :quiz do 
    sequence(:name) { |n| "Quiz Number #{n}"}
    description "This is a quiz created by Factory Girl."
    published true
    association :author, factory: :user
    category_id 1
    subject_id 1
    factory :quiz_with_questions do |qz|
      qz.questions { |questions| [questions.association(:question),questions.association(:question)] }
    end
    factory :small_quiz do |qz|
      qz.questions { |questions| [questions.association(:question),questions.association(:question)] }
    end    
  end

  factory :question do |q|
    q.content "WhyWhyWhy!"
    q.question_type "MC-2"
    q.answers { |answers| [answers.association(:answer_correct), answers.association(:answer_incorrect)] }
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

end

  