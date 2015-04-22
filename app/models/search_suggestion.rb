class SearchSuggestion
  IGNORE_TERMS = %w(and the to but of for)
  KEY_STRING = "search-suggestions"

  def self.terms_for(prefix)
    $redis.zrevrange "#{KEY_STRING}:#{prefix.downcase}", 0, 9
  end

  def self.index_quizzes
    Quiz.published.includes(:category, :subject).find_each do |quiz|
      index_quiz(quiz)
    end
  end

  def self.index_quiz(quiz)
    terms_for_quiz(quiz).each { |term| index_term(term) }
  end

  def self.unindex_quiz(quiz)
    terms_for_quiz(quiz).each { |term| unindex_term(term) }
  end

  def self.clear
    $redis.keys.each do |key|
      $redis.del key if key.start_with?(KEY_STRING)
    end
  end

  private
  
  def self.index_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0, n]
      $redis.zincrby "#{KEY_STRING}:#{prefix}", 1, term.downcase
    end
  end

  def self.unindex_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0,n]
      $redis.zincrby "#{KEY_STRING}:#{prefix}", -1, term
      $redis.zremrangebyscore "#{KEY_STRING}:#{prefix}", -Float::INFINITY, 0
    end
  end

  def self.terms_for_quiz(quiz)
    terms = collect_terms_from(quiz.name)
    terms << collect_terms_from(quiz.category_name)
    terms << collect_terms_from(quiz.subject_name)
    terms.flatten
  end

  def self.collect_terms_from(term)
    term.downcase!
    terms = term.split[1..-1] << term
    terms.reject { |term| IGNORE_TERMS.include?(term) }
  end
end
