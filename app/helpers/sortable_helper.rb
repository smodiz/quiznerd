#:nodoc:
module SortableHelper
  def sortable_link(column, title = nil)
    title ||= column.titleize
    direction =
      (column == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'
    link_to title,
            params.merge(sort: column, direction: direction, page: 1),
            class: 'sortable-link'
  end

  def sortable_css_class(column)
    column == sort_column ?  current_header : 'sortable-header'
  end

  def current_header
    "sortable-header current #{sort_direction}"
  end
end
