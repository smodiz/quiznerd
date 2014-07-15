
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
    
    factory :quiz_with_questions do
      after(:create) do |quiz|
        create(:question_mc2_with_answers, quiz: quiz)
        create(:question_mc1_with_answers, quiz: quiz)
        create(:question_mc1_with_answers, quiz: quiz)
      end
    end

     factory :quiz_with_question do
      after(:create) do |quiz|
        create(:question_mc2_with_answers, quiz: quiz)
      end
    end
  end

  factory :question do
    sequence(:content) { |n| "Question number #{n}"}
    remarks "These are some remarks to show the user after they answer"
    question_type "MC-2"

    factory :question_mc2_with_answers do
      after(:create) do |question|
        create(:answer_correct, question: question)
        create(:answer_incorrect, question: question)
        create(:answer_correct, question: question)
        create(:answer_incorrect, question: question)
      end
    end
    factory :question_mc1_with_answers do
      question_type "MC-1"
      after(:create) do |question|
        create(:answer_incorrect, question: question)
        create(:answer_incorrect, question: question)
        create(:answer_correct, question: question)
        create(:answer_incorrect, question: question)
      end
    end
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

    #  :id => :integer,
    #          :user_id => :integer,
    #          :quiz_id => :integer,
    #           :status => :string,
    #    :total_correct => :integer,
    #   :total_answered => :integer,
    # :last_question_id => :integer,
