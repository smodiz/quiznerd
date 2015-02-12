
$(document).ready( function(){
  rememberOriginalSettings();
  process.init();
  process.advance();
  process.answer();
  if (isFiltered()  && isValidCount()) {
    playFlashCards();
  }
  else {
    $('.new-deck-event-btn').focus();
  }

});

// <!-- functions -->

function isValidCount() {
  return ($('#flash-card-set-count').text() > 0);
}
function isFiltered() {
  return $('#filtered').val();
}
function rememberOriginalSettings() {
  $('.deck-event-option').each(function() {
   var elem = $(this);
   elem.data('oldVal', elem.val());
  });
}
function playFlashCards() {
  $('.options-section').hide();
  $('.de-flash-card-side').first().show();
  $('.de-flash-card-side').first().find('.flash-advance').focus();
}
function changesMadeToFilters() {
  changes = false;
  $('.deck-event-option').each(function() {
    var elem = $(this);
    if (elem.data('oldVal') != elem.val()) {
      changes = true;
      return false;
    }
  });
  return changes;
}


var process = {
  init: function() {
    $('.new-deck-event-btn').on('click', function(event){
      if (!changesMadeToFilters() && isValidCount()) {
        event.preventDefault();
        playFlashCards();
      }
    });
  },
  advance: function() {
    event.preventDefault();
    $('.flash-advance').on('click', function(event){
      $(this).closest('.de-flash-card-side').next().show();
      $(this).closest('.de-flash-card-side').hide();
      $(this).closest('.de-flash-card-side').next().find('.correct-flash-answer').focus();
      
    });
  },
  answer: function() {
    event.preventDefault();
    $('.flash-answer').on('click', function(event){

      //first, deal with grading
      if ($(this).attr("class").match(/incorrect/)) {
        var id = $(this).attr("id").split("-")[2];
        var missed_cards_list = $('#deck_event_missed_cards_list').val();
        if (missed_cards_list && missed_cards_list.length > 0) {
          missed_cards_list += ","
        }
        missed_cards_list += id
        $('#deck_event_missed_cards_list').val(missed_cards_list);
      }
      else {
        var currentCount = parseInt($('#deck_event_total_correct').val());
        $('#deck_event_total_correct').val(currentCount + 1);
      }
      //then, display the next one or the finished message  
      $(this).closest('.de-flash-card-side').hide();
      if($(this).closest('.de-flash-card-side').next()[0] == null) {
        $('#de-finished').show();
        $('.de-form-actions').show();
        var correct = parseInt($('#deck_event_total_correct').val());
        var total = parseInt($('#deck_event_total_cards').val());
        var score = (correct/total * 100).toFixed(0);
        $('#de-score').text("You scored " + score + "%!");
         $(this).off('click'); 
        $('#new_deck_event').find('.btn-primary').focus();
      }
      else {
        $(this).closest('.de-flash-card-side').next().show();
        $(this).closest('.de-flash-card-side').next().find('.flash-advance').focus();
      }
        

      

    });
  }
}