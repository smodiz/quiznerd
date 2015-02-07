$(document).ready(function(){
  $( "#sortable" ).sortable();
  $( "#sortable" ).disableSelection();
  
  $('.flash-cards-container').on('click', '#done', function(event) {
    event.preventDefault();
    $('#new_flash_card').remove();
    $('#new_link').show();
  });
 
});