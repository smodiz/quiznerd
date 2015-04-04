module Gradeable
  def grade
    Grade.new(total_correct, total_answered)
  end
end
