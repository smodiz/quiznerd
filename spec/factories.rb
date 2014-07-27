
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
  end

  factory :quiz do
    sequence(:name) { |n| "Quiz Number #{n}"}
    description "This is a quiz created by Factory Girl."
    published true
    category_id 1
    subject_id 1
    
    factory :quiz_with_questions do
      after(:create) do |quiz|
        create(:question, quiz: quiz)
        create(:question, quiz: quiz)
        create(:question, quiz: quiz)
      end
    end

    factory :quiz_with_question do
      after(:create) do |quiz|
        create(:question, quiz: quiz)
      end
    end


  end


  # factory :quiz do
  #   sequence(:name) { |n| "Quiz Number #{n}"}
  #   description "This is a quiz created by Factory Girl."
  #   published true
  #   category_id 1
  #   subject_id 1
  # end

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

  