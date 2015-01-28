
$(document).ready(function() {
  $('#question_question_type').on('click', set_true_false_defaults);

  $('form').on('click','.destroy_checkbox',function() {
      $(this).closest('.answer-row').hide();
  });

  $('form').on('click', '.add_fields', function(event) {
    event.preventDefault();
    var unique_id = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    var answer = $(this).data('fields').replace(regexp, unique_id);
    $(this).closest('table').find('tr').last().before(answer);
    
    //have to manually add the bootstrap classes
    var inserted = $(this).closest('table').find('tr').last().prev();
    $(inserted).find('label').first().addClass('col-sm-3');
    $(inserted).find('.form-group').find('div').addClass('col-sm-9');
  });
  
});

//remove extra answers; we just need True and False
function set_true_false_defaults() {
    if ($(this).val() == "T/F") {
      var num_answers = $('.answer-row:visible').length;
      
      for(i = 1; i <= (num_answers - 2); i++) {   
        $('.answer-row:visible').last().
          find('.question_answers__destroy').
          find('input').val('1');
        $('.answer-row:visible').last().hide();
      }
      $('.answer-row:visible').last().find('textarea').val("False");
      $('.answer-row:visible').first().find('textarea').val("True");
    }
}

