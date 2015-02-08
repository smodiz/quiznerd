$(document).ready(function(){
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  
  $('.flash-cards-container').on('click', '#done', function(event) {
    event.preventDefault();
    $('.flash-card-form').remove();
    $('#new_link').show();
  });
 
});