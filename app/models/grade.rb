#:nodoc:
class Grade
  def initialize(total_correct, total_answered)
    @total_correct = total_correct
    @total_answered = total_answered
  end

  def percent
    @percent ||=
      data_present? ? ((correct.to_f / answered.to_f) * 100).round : 0
  end

  def data_present?
    answered > 0
  end

  def answered
    @total_answered || 0
  end

  def correct
    @total_correct || 0
  end
end
