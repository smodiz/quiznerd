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

 
  def text_area_rows(content, field_width = 50)
    rows = [2]
    if content.present?
        rows << calculate_by_length(content.length, field_width) + 
          number_of_newlines(content)
    end
    rows.max
  end

  private

    def number_of_newlines(text)
      newlines = text.split(/\r\n/).length
    end

    def calculate_by_length(length, width)
      (length.to_f/width).ceil + 1
    end
  
  
end
