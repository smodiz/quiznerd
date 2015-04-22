namespace :search_suggestions do
  desc "Generate search suggestions for public quizzes"
  task :index => :environment do
    SearchSuggestion.index_quizzes
  end

  desc "Delete all search suggestions for public quizzes"
  task :reset => :environment do
    SearchSuggestion.clear
  end
end
