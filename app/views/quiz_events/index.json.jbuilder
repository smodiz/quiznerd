json.array!(@quiz_events) do |quiz_event|
  json.extract! quiz_event, :id, :user_id, :quiz_id, :number_correct, :number_questions
  json.url quiz_event_url(quiz_event, format: :json)
end
