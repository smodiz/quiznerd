module DecksHelper

  def new_deck_button
    link_to \
      '<i class="glyphicon glyphicon-plus glyphicon-white"></i> New Flash Deck'.html_safe, 
      new_deck_path, class: 'btn btn-primary pull-right btn-sm' 
  end

end