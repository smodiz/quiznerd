require 'spec_helper'

describe "Quiz Taking Form" do 

  let(:quiz_event)  { FactoryGirl.create(:quiz_event) }
  let(:quiz) { quiz_event.quiz }
  let(:quiz_taking_form) { QuizTakingForm.new(quiz_event: quiz_event) }

  subject { quiz_taking_form }

  it "requires an answer when submitting" do
    expect(submit_form_for(:no_answer)).to be_false  
  end

  context "when starting a quiz" do 
    it "starts with the first question" do
      first = quiz.first_question_id
      expect(quiz_taking_form.question.id).to eq first
    end

    it "has no graded question yet" do
      expect(quiz_taking_form.graded_question).to be_nil
    end
  end

  context "when answering a question incorrectly" do 
    before(:each) do
      submit_form_for(:incorrect)     
    end

    it "has a graded answer which shows it as incorrect" do
      expect(quiz_taking_form.graded_question.id).to eq @question.id
      expect(quiz_taking_form.answer_correct?).to be_false
    end

    it "serves the next question up" do
      expect(quiz_taking_form.question).to eq @next_question
    end
  end

  context "when answering a question correctly" do 
    before(:each) do
      submit_form_for(:correct)
    end

    it "has a graded answer which shows it as correct" do
      expect(quiz_taking_form.graded_question.id).to eq @question.id
      expect(quiz_taking_form.answer_correct?).to be_true
    end

    it "serves the next question up" do
      expect(quiz_taking_form.question).to eq @next_question
    end
  end  

  context "when answering the last question" do
    before(:each) do
      @question = quiz.questions.last
      quiz_event.total_answered = quiz_event.number_of_questions - 1
      answer = @question.correct_answer_ids
      params = { question_id: @question.id, answer_ids: answer }
      quiz_taking_form.submit(params)
    end

    it "has a graded question" do
      expect(quiz_taking_form.graded_question.id).to eq @question.id
      expect(quiz_taking_form.answer_correct?).to be_true
    end

    it "does not have a next question" do
      expect(quiz_taking_form.question).to be_nil  
    end

    it "has a status of completed" do
      expect(quiz_taking_form.quiz_event).to be_completed
    end
  end

  context "user is answering same question twice" do
    before(:each) do
      submit_form_for(:incorrect)
      submit_form_for(:correct)
    end

    it "show the user the error message" do
      expect(quiz_taking_form.errors[:question_id].to_s).to match(/more than once/)
    end

    it "displaya the correct question for them to answer" do
      expect(quiz_taking_form.question_id).to eq quiz.questions[1].id
    end

    it "does not impact the grade" do
      expect(quiz_event.current_percent_grade).to eq 0.0
    end
  end

  context "user is re-answering question after quiz completed" do
    before(:each) do
      quiz_event.total_answered = quiz_event.number_of_questions
      quiz_event.total_correct = 0
      quiz_event.last_question_id = quiz.questions.last.id  
      submit_form_for(:correct)
    end

    it "show the user the error message" do
      expect(quiz_taking_form.errors[:base].to_s).to match(/already completed/i)
    end

    it "is still completed" do
      expect(quiz_taking_form.quiz_completed?).to be_true
    end

    it "does not impact the grade" do
      expect(quiz_event.current_percent_grade).to eq 0.0
    end
  end


  def submit_form_for(answer_type)
    @question = quiz.questions[0]
    @next_question = quiz.questions[1]
    answer = case answer_type
      when :correct then @question.correct_answer_ids
      when :incorrect then [9999]
      when :no_answer then []
      end
    params = { question_id: @question.id, answer_ids: answer }
    quiz_taking_form.submit(params)
  end

end