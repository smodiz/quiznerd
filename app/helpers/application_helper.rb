module ApplicationHelper
  
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def full_title(page_title)
    title = "Quiz Nerd"
    title += " | #{page_title}" unless page_title.empty? 
    title   
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new( hard_wrap: true, 
                                            filter_html: true,
                                            safe_links_only: true)
    markdown = Redcarpet::Markdown.new( renderer, 
                                        autolink: true, 
                                        space_after_headers: true,
                                        fenced_code_blocks: true,
                                        disable_indented_code_blocks: true,
                                        underline: true,
                                        highlight: true,
                                        quotes: true,
                                        no_intra_emphasis: true,
                                        tables: true)
    markdown.render(text).html_safe
  end

  
  # Calculate the number of rows a text area should have in order
  # to display all the existing text
  def text_area_rows(content, field_width = 50, min=2)
    rows = [min]
    if content.present?
        rows << calculate_by_length(content.length, field_width) + 
          number_of_newlines(content)
    end
    rows.max
  end

  def score(total_correct, total_items)
    if total_items.present? && total_items > 0 && total_correct.present?
      "%.0f" % ((total_correct.to_f / total_items.to_f) * 100)
    else
      0
    end
  end

  def formatted_score_string(total_correct, total_items)
    score = score(total_correct, total_items)
    "#{score}% (#{total_correct} out of #{total_items})"
  end

  private

    def number_of_newlines(text)
      newlines = text.split(/\r\n/).length
    end

    def calculate_by_length(length, width)
      (length.to_f/width).ceil + 1
    end
  
  
end