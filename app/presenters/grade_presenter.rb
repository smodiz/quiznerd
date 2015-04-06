#:nodoc:
class GradePresenter
  def self.short_score(grade)
    "#{grade.percent}%"
  end

  def self.long_score(grade)
    "#{grade.percent}% (#{grade.correct} out of #{grade.answered})"
  end

  def self.long_score_with_time(grade, time, view_context)
    "You scored #{long_score(grade)} \
       #{view_context.time_ago_in_words(time)} ago!"
  end
end
