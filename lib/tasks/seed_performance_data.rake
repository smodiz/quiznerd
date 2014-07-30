namespace :data do

  task :seed_big => :environment do 
    num_records = 1000
    puts "\nStarting insertion of large amount of data ...."
    
    num_records.times do |n|
      quiz = Quiz.new(name: "Quiz From Seeds - #{n}", author_id: 2, 
        category: Category.first, subject: Subject.first, 
        description: "Seeded quiz #{n} for performance testing." , published: true)
      questions = []
      50.times do |i|
        answers = []
        4.times do |k|
          answers << Answer.new(content: "Answer #{k}", correct: (k.even? ? true : false))
        end
        questions << Question.new(content: "This is seeded question #{i}", 
          question_type: "MC-2", answers: answers)
      end
      quiz.questions = questions
      quiz.save!
    end
    puts "\nEnd"
  end

end

