function autoresize(textarea) {
    textarea.style.height = '0px';  
    textarea.style.height = (textarea.scrollHeight+20) + 'px'; 
}

$(document).ready(function(){
  $("textarea.autosize").each(function () {
    autoresize(this);
    $(this).keyup(function () {
      autoresize(this);
    });
  });
});