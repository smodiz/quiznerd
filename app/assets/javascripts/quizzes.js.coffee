jQuery -> 
  subjects = $('#quiz_subject_id').html()
  $('#quiz_category_id').change ->
    category = $('#quiz_category_id :selected').text()
    escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(subjects).filter("optgroup[label=#{escaped_category}]").html()
    if options
      $('#quiz_subject_id').html(options)
    else
      $('#quiz_subject_id').empty()
