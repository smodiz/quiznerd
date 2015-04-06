#:nodoc:
module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def full_title(page_title)
    title = 'Quiz Nerd'
    title += " | #{page_title}" unless page_title.empty?
    title
  end

  def markdown(text)
    markdown_maker.render(text).html_safe
  end

  def flash_class(flash_type)
    case flash_type
    when 'success' then 'alert-success'
    when 'error' then 'alert-danger'
    when 'alert' then 'alert-warning'
    when 'notice' then 'alert-info'
    else flash_type.to_s
    end
  end

  private

  def markdown_maker
    @markdown ||= Redcarpet::Markdown.new(renderer,
                                          autolink: true,
                                          space_after_headers: true,
                                          fenced_code_blocks: true,
                                          disable_indented_code_blocks: true,
                                          underline: true,
                                          highlight: true,
                                          quotes: true,
                                          no_intra_emphasis: true,
                                          tables: true)
  end

  def renderer
    @renderer ||= Redcarpet::Render::HTML.new(hard_wrap: true,
                                              filter_html: true,
                                              safe_links_only: true)
  end
end
