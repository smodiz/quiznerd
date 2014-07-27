require 'spec_helper'

describe "Quiz Pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:quiz) { FactoryGirl.create(:quiz, author: user) }
  let(:quiz_with_questions) { FactoryGirl.create(:quiz_with_questions, 
      author: user, published: false) }

  subject { page }

  before(:each) { valid_sign_in(user) }

  describe "shows a quiz on the index page" do
    before(:each) do
      quiz.save
      visit quizzes_path
    end
    
    it { should have_content("Quizzes Written") }
    it { should have_content(quiz.name) }
    it { should have_content(quiz.description) }
    it { should have_content(quiz.category.name) }
    it { should have_content(quiz.subject.name) }
    it { should have_content(quiz.published ? "Yes" : "No") }
    it { should have_link("New Quiz") }
  end

  describe "does not show other users quiz" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:quiz2) { FactoryGirl.create(:quiz, author: user2) }
    before(:each) do
      quiz2.save
      visit quizzes_path
    end
    it { should_not have_content(quiz2.name) }
  end

  describe "show new quiz page" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
    end

    it { should have_content("New quiz") }
    it { should have_button("Create Quiz") }
    it { should have_link("Cancel") }
  end

  describe "create new quiz" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      fill_in "Name", with: quiz.name
      fill_in "Description", with: quiz.description
      select quiz.category.name, :from => 'Category'
      select quiz.subject.name, :from => 'Subject'
      click_button "Create Quiz"
    end

    it { should have_content("Quiz was successfully created") }
    it { should have_content(quiz.name) }
  end

  describe "create new quiz with a new category and subject" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      fill_in "Name", with: quiz.name
      fill_in "Description", with: quiz.description
      fill_in "or create a new category:", with: "Geography"
      fill_in "or create a new subject:", with: "North American Rivers"
      click_button "Create Quiz"
    end

    it { should have_content("Quiz was successfully created") }
    it { should have_content("Geography") }
    it { should have_content("North American Rivers") }
  end

  describe "cancel create new quiz" do
    before(:each) do
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      click_link "Cancel"
    end
    it "should return to the quizzes list" do
      expect(current_path).to eq(quizzes_path)
    end
  end

  describe "delete a quiz" do
    before(:each) do
      quiz.save
      visit quizzes_path
      click_link("destroy")
    end

    it { should have_content("Quizzes Written")  }
    it { should_not have_content(quiz.name) }
  end

  describe "as wrong user" do
    let(:wrong_user) { FactoryGirl.create(:user) }
    let(:quiz) { FactoryGirl.create(:quiz, author: wrong_user) }

    describe "submitting a GET request to the Quizzes#edit action" do
      before { get edit_quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end

    describe "submitting a PATCH request to the Quizzes#update action" do
      before { patch quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end

    describe "submitting a DELETE request to the Quizzes#destroy action" do
      before { delete quiz_path(quiz) }
      specify { expect(current_path).to eq(root_path)}
    end
  end

  describe "show quiz" do
    before(:each) do 
      quiz.save!
      visit quizzes_path
      click_link quiz.name
    end
    
    specify { expect(current_path).to eq(quiz_path(quiz))}
    it { should have_content(quiz.name) }
    it { should have_link("Edit Quiz Information") }
    
    it { should have_content("Questions") }
    it { should have_link("Add Question") }
    it "should not have Publish link without minimum number of questions" do
      expect(page).to_not have_link("Publish Quiz") 
    end
  end

  describe "edit quiz" do
    before(:each) do 
      quiz.save!
      visit quizzes_path
      click_link quiz.name
      click_link "Edit Quiz Information"
    end
    
    specify { expect(current_path).to eq(edit_quiz_path(quiz))}
    it { should have_content("Edit quiz") }
    it { should have_button("Update Quiz") }
    it { should have_link("Cancel") }

  end


  describe "publish a quiz" do
    before(:each) do
      quiz_with_questions.save!
      visit quiz_path(quiz_with_questions)
      click_link "Publish Quiz"
    end

    specify { expect(current_path).to eq(quiz_path(quiz_with_questions)) }
    it { should have_link("Unpublish Quiz") }
    it { should have_content("Published? Yes") }
  end

  describe "unpublish a quiz" do
     before(:each) do
      quiz_with_questions.published = true
      quiz_with_questions.save!
      visit quiz_path(quiz_with_questions)
      click_link "Unpublish Quiz"
    end
    
    specify { expect(current_path).to eq(quiz_path(quiz_with_questions)) }
    it { should have_link("Publish Quiz") }
    it { should have_content("Published? No") }
  end

  describe "quizzes_written page has sortable columns" do
    let(:cat_2) { Category.find_or_create_by(name: "Aaa") }
    let(:sub_2) { Subject.find_or_create_by(name: "Zzz", category: cat_2) }
    let(:cat_3) { Category.find_or_create_by(name: "Zzz") }
    let(:sub_3) { Subject.find_or_create_by(name: "Aaa", category: cat_3) }
    let(:quiz_2) do
      FactoryGirl.create( :quiz, name: "Aaa", category: cat_2, subject: sub_2, 
        published: false, author: user )
    end
    let(:quiz_3) do
      FactoryGirl.create( :quiz, name: "Zzz", category: cat_3, subject: sub_3, 
        published: true, author: user )
    end

    before(:each) do
      quiz.save
      quiz_2.save
      quiz_3.save
      visit quizzes_path
    end

    it { should have_link("Name")}
    it { should have_link("Published") }
 
    describe "sorting by name" do
      before(:each) { click_link "Name" }
  
      it "should sort by name" do
        expect(quiz_2.name).to appear_before(quiz.name)
      end
    end

    describe "sorting by published" do
      before(:each) { click_link "Published" }
  
      it "should sort by published" do
        expect(quiz_2.name).to appear_before(quiz_3.name)
      end
    end
 

    describe "sorting by published in reverse order" do
      before(:each) do
       click_link "Published" 
       click_link "Published" 
     end
  
      it "should reverse the order" do
        expect(quiz_3.name).to appear_before(quiz_2.name)
      end
    end

  end  

end
