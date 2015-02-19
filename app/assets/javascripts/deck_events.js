
$(document).ready( function(){
  
  init();
  showAnswer();
  processAnswer();
  if (isFiltered()  && isValidCount()) {
    playFlashCards();
  }
  else {
    $('.new-deck-event-btn').focus();
  }
  $('.scratchpad-show').on('click', function(){
    $('.scratchpad').show();
    $('.scratchpad textarea').focus();
  });
  $('.scratchpad-hide').on('click', function(){
    $('.scratchpad').hide();
    $('.scratchpad textarea').val("");
  });
});

// functions 

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
function changesMadeToFilters() {
  var changed = false;
  $('.deck-event-option').each(function() {
    var elem = $(this);
    if (elem.data('oldVal') != elem.val()) {
      changed = true;
      exit;
    }
  });
  return changed;
}
var init = function() {
  $('.new-deck-event-btn').on('click', function(event){
    if (!changesMadeToFilters() && isValidCount()) {
      event.preventDefault();
      rememberOriginalSettings();
      playFlashCards();
    }
  });
}
function playFlashCards() {
  $('.options-section').hide();
  $('.de-flash-card-side').first().show();
  $('.de-flash-card-side').first().find('.flash-advance').focus();
}
var processAnswer = function() {
  $('.flash-answer').on('click', function(event){

    //first, deal with grading
    gradeAnswer(this);

    //then, display the next one or the finished message  
    $(this).closest('.de-flash-card-side').hide();
    if($(this).closest('.de-flash-card-side').next()[0] == null) {
      showScore();
    }
    else {
      advanceToNext(this);
    }
  });
}
var gradeAnswer = function(elem) {
  if ($(elem).attr("class").match(/incorrect/)) {
    var id = $(elem).attr("id").split("-")[2];
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
}
var advanceToNext = function(elem) {
  $('.scratchpad textarea').val("");
  $(elem).closest('.de-flash-card-side').next().show();
  $(elem).closest('.de-flash-card-side').next().find('.flash-advance').focus();
}
var showScore = function() {
  $('.scratchpad').hide();
  $('#de-finished').show();
  $('.de-form-actions').show();
  var correct = parseInt($('#deck_event_total_correct').val());
  var total = parseInt($('#deck_event_total_cards').val());
  var score = (correct/total * 100).toFixed(0);
  $('#de-score').text("You scored " + score + "%!");
  $(this).off('click'); 
  $('#new_deck_event').find('.btn-primary').focus();
}
var showAnswer = function() {
  $('.flash-advance').on('click', function(event){
    $(this).closest('.de-flash-card-side').next().show();
    $(this).closest('.de-flash-card-side').hide();
    $(this).closest('.de-flash-card-side').next().find('.correct-flash-answer').focus();
  });
}
