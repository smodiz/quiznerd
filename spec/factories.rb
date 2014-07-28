
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
     name "Category FactoryGirl Testing"
  end

  factory :quiz_without_questions, class: Quiz do 
    sequence(:name) { |n| "Quiz Number #{n}"}
    # qz.name "Quiz from the factory"
    description "This is a quiz created by Factory Girl."
    published true
    category_id 1
    subject_id 1
  end

  factory :quiz do |qz|
    sequence(:name) { |n| "Quiz Number #{n}"}
    # qz.name "Quiz from the factory"
    qz.description "This is a quiz created by Factory Girl."
    qz.published true
    category_id 1
    subject_id 1
    qz.questions { |questions| [questions.association(:question),questions.association(:question)] }
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
  end

end

  