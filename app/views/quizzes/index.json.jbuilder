json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :name, :description, :author_id, :published, :category_id, :subject_id
  json.url quiz_url(quiz, format: :json)
end
