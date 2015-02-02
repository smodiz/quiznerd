module CheatsheetsHelper

  def new_cheatsheet_button
    link_to '<i class="glyphicon glyphicon-plus glyphicon-white"></i> New Cheatsheet'.html_safe, 
      new_cheatsheet_path, class: 'btn btn-primary pull-right btn-sm' 
  end

end