jQuery(function() {
  
  // Textify form submits
  jQuery('.action input[type=submit]').each(function() {
    var $textSubmit = jQuery('<a href="#" class="highlight">' + $(this).val() + '</a>');
    $(this)
      .hide()
      .after($textSubmit);
    $textSubmit.click(function() {
      $(this).parent('form').submit();
      return false;
    });
  })
});