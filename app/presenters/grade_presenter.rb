class GradePresenter

  def self.short_score(grade)
    "#{grade.percent}%"
  end

  def self.long_score(grade)
    "#{grade.percent}% (#{grade.correct} out of #{grade.answered})"
  end

end
