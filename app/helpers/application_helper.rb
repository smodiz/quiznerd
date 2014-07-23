module ApplicationHelper
  
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

  def formatted_quiz_score(quiz_event)
    "%.0f" % quiz_event.current_percent_grade
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, page: 1), 
      { class: "sortable-link" }
  end

 def sortable_css_class(column)
    column == sort_column ? "sortable-header current #{sort_direction}" : "sortable-header"
  end

  
end
