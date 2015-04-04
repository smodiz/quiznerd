module SortableColumns
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end

  def sort_column
    valid_sort_column?(allowed_sorting_columns) ? params[:sort] : "1"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sort_clause
    "#{sort_by_rank} #{sort_column} #{sort_direction}"
  end

  def sort_by_rank
    if params[:search].present?
      "pg_search_rank desc, "
    else
      ""
    end
  end

  def allowed_sorting_columns
    # the default implementation is that you can sort by all the columns of the
    # model associated with the controller that included this module.
    # Override if needed.
    controller_name.classify.constantize.column_names
  end

  def valid_sort_column?(allowed=[])
    allowed.include?(params[:sort])
  end
end
