$(document).ready(function(){
  
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  
  $('.flash-cards-container').on('click', '#done', function(event) {
    event.preventDefault();
    $('#new_link').show();

  });
 
});