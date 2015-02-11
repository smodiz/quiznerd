module DeckEventsHelper

  def thumbs_up_link(flash_card)
    id = "correct-answer-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-thumbs-up glyphicon-white"></i>'
    link_to icon.html_safe, 
            '#', 
            class: 'btn btn-success btn-sm correct-flash-answer flash-answer',
              id: id
  end

  def thumbs_down_link(flash_card)
    id = "incorrect-answer-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-thumbs-down glyphicon-white"></i>'
      link_to icon.html_safe, 
              '#', 
              class: 'btn btn-danger btn-sm incorrect-flash-answer flash-answer',
              id: id
  end

  def advance_flash_card_link(flash_card)
    id = "advance-#{flash_card.id}"
    icon = '<i class="glyphicon glyphicon-arrow-right glyphicon-white"></i>'
    link_to icon.html_safe, 
            '#', 
            class: 'btn btn-primary btn-sm flash-advance',
              id: id
    end
end