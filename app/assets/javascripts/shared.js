function autoresize(textarea) {
    textarea.style.height = '0px';  
    textarea.style.height = (textarea.scrollHeight+10) + 'px'; 
}

$(document).ready(function(){
  $("textarea").each(function () {
    autoresize(this);
    $(this).keyup(function () {
      autoresize(this);
    });
  });
});