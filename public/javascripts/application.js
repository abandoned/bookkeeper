$(document).ready(function() {
  setTimeout("$('#flash_notice').slideUp('fast')", 3000);
  $('select.autocomplete').select_autocomplete();
})

(function($) {
		  
	$.fn.use_label_as_default = function() {
	  console.log("ok");
  };
})(jQuery);
