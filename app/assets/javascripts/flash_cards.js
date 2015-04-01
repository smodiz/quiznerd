$(document).ready(function(){  
  $('.flash-cards-container').on('click', '#done', function(event) {
    event.preventDefault();
    $('form').remove();
    $('#new_link').show();
  });
});