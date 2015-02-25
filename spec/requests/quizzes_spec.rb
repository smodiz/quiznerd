require 'spec_helper'

describe "Quiz Pages" do

  let(:quiz) { FactoryGirl.create(:quiz_with_questions) }

  subject { page }

  before(:each) do
    valid_sign_in(quiz.author) 
  end

  describe "shows a quiz on the index page" do
    before(:each) do
      visit quizzes_path
    end
    
    it { should have_content("Quizzes Written") }
    it { should have_content(quiz.name) }
    it { should have_content(quiz.description) }
    it { should have_content(quiz.category.name) }
    it { should have_content(quiz.subject.name) }
    it { should have_content(quiz.published ? "Yes" : "No") }
    it "should have a 'New Quiz' link" do
      within('.panel-body') do
        expect(page).to have_link('New Quiz')
      end
    end
  end

  describe "does not show other users quiz" do
    let(:user2) { FactoryGirl.create(:user) }
    let(:quiz2) { FactoryGirl.create(:quiz_with_questions, author: user2) }
    before(:each) do
      quiz2   #need to access variable before page load
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

    it { should have_content("Quiz was successfully saved") }
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
      fill_in "new_category", with: "Geography"
      fill_in "new_subject", with: "North American Rivers"
      click_button "Create Quiz"
    end

    it { should have_content("Quiz was successfully saved") }
    it { should have_content("Geography") }
    it { should have_content("North American Rivers") }
    it "should not have Publish related links without minimum number of questions" do
      expect(page).to_not have_link("Publish") 
      expect(page).to_not have_link("Unpublish") 
    end
    it "should not have Take Quiz link without minimum number of questions" do
      expect(page).to_not have_link("Take Quiz") 
    end

  end

  describe "create a new quiz with a new category with duplicate name" do
    before(:each) do
      Category.create(name: "Geography")
      visit quizzes_path
      within(".page-actions") do
        click_link "New Quiz"
      end
      fill_in "Name", with: quiz.name
      fill_in "Description", with: quiz.description
      fill_in "new_category", with: "Geography"
      fill_in "new_subject", with: "North American Rivers"
      click_button "Create Quiz"
    end
    it "should not create another category" do
      expect(Category.where(name: "Geography").size).to eq 1 
    end
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
      visit quizzes_path
      click_link("delete-link")
    end

    it { should have_content("Quizzes Written")  }
    it { should_not have_content(quiz.name) }
  end

  describe "as wrong user" do
    let(:wrong_user) { FactoryGirl.create(:user) }
    let(:quiz) { FactoryGirl.create(:quiz_with_questions, author: wrong_user) }

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
      visit quizzes_path
      click_link quiz.name
    end
    
    specify { expect(current_path).to eq(quiz_path(quiz))}
    it { should have_content(quiz.name) }
    it { should have_link("Edit") }
    
    it { should have_content("Questions") }
    it { should have_link("Add Question") }
    it { should have_link("Unpublish") }
    it { should have_link("Take Quiz") }
 
  end

  describe "delete a quiz from the show page" do 
    before(:each) do 
      visit quiz_path quiz
      click_link("Delete") 
    end
    specify { expect(current_path).to eq(quizzes_path)}
    it { should_not have_content(quiz.name) }
  end


  describe "edit quiz" do
    before(:each) do 
      visit quizzes_path
      click_link quiz.name
      click_link "Edit"
    end
    
    specify { expect(current_path).to eq(edit_quiz_path(quiz))}
    it { should have_content("Edit") }
    it { should have_button("Update") }
    it { should have_link("Cancel") }

  end


  describe "publish a quiz" do
    before(:each) do
      quiz.published = false
      quiz.save!
      visit quiz_path(quiz)
      click_link "Publish"
    end

    specify { expect(current_path).to eq(quiz_path(quiz)) }
    it { should have_link("Unpublish") }
    it { should have_content("Published? Yes") }
  end

  describe "unpublish a quiz" do
     before(:each) do
      visit quiz_path(quiz)
      click_link "Unpublish"
    end
    
    specify { expect(current_path).to eq(quiz_path(quiz)) }
    it { should have_link("Publish") }
    it { should have_content("Published? No") }
  end

  describe "quizzes_written page has sortable columns" do
    let(:cat_2)   { Category.find_or_create_by(name: "Aaa") }
    let(:sub_2)   { Subject.find_or_create_by(name: "Zzz", category: cat_2) }
    let(:cat_3)   { Category.find_or_create_by(name: "Zzz") }
    let(:sub_3)   { Subject.find_or_create_by(name: "Aaa", category: cat_3) }
    let(:quiz_2)  { FactoryGirl.create(:quiz, name: "Aaa", author: quiz.author,
                      category: cat_2, subject: sub_2, published: false) }
    let(:quiz_3)  { FactoryGirl.create( :quiz, name: "Zzz", author: quiz.author,
                      category: cat_3, subject: sub_3, published: true) }

    before(:each) do
      quiz; quiz_2; quiz_3; # touch so they exist
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
