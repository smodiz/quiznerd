$(document).ready(function(){
  if ($('form').attr('action') == '/search') {
    $('#search').autocomplete({
      source: "/search_suggestions"
    });
  }
});
