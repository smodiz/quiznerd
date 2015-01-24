module CheatsheetsHelper

  def new_cheatsheet_button(min_set_size: 1)
    if @cheatsheets.size >= min_set_size
      link_to '<i class="glyphicon glyphicon-plus glyphicon-white"></i> New Cheatsheet'.html_safe, 
        new_cheatsheet_path, class: 'btn btn-primary pull-right btn-sm' 
    end
  end

end