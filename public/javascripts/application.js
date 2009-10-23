$(document).ready(function() {
  
  // Pauses animation
  $.fn.pause = function(duration) {
      $(this).animate({ dummy: 1 }, duration);
      return this;
  };
  
  // Animate flash messages
  $("#flash_notice").pause(3000).slideUp(100);
});