//dynamically add and remove answers, plus if the question type
//is true/false, default the possible answers to true and false
$(document).ready(function() {
  $('#question_question_type').on('click', setTrueFalseDefaults);

  $('form').on('click','.destroy',function() {
      $(this).closest('.answer-row').hide();
  });

  $('form').on('click', '.add_fields', function(event) {
    event.preventDefault();
    var unique_id = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    var answer = $(this).data('fields').replace(regexp, unique_id);
    $(this).closest('table').find('tr').last().before(answer);
  });
});

//remove extra answers (or add, if necessary) so that we
//just have 2 answers: True and False
function setTrueFalseDefaults() {
    if ($(this).val() == "T/F") {
      var num_answers = $('.answer-row:visible').length;
      for(i = 1; i <= (num_answers - 2); i++) {
        $('.answer-row:visible').last().
          find('.question_answers__destroy').
          find('input').val('1');
        $('.answer-row:visible').last().hide();
      }
      for(i = 1; i <= (2 - num_answers); i++) {
          $('.add_fields').trigger('click');
      }
      $('.answer-row:visible').last().find('textarea').val("False");
      $('.answer-row:visible').first().find('textarea').val("True");
    }
}

