$(function() {
  
  // Textify form submits
  $('.textify').each(function() {
    var $textSubmit = $('<a href="#" class="highlight">' + $(this).val() + '</a>');
    $(this)
      .hide()
      .after($textSubmit);
    $textSubmit.click(function() {
      $(this).parent('form').submit();
      return false;
    });
  });
});