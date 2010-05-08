(function($) {
 
  $.fn.obesify = function(data, options) {
    if (data == null) { return; }
    
    var defaults = {
      minChars: 0,
      multiple: true,
      matchContains: true,
      autoFill: false,
      multipleSeparator : "; "
    }
    options = $.extend(defaults, options || {});
    
    // Did I just collect?
    var triggers = [];
    $.each(data, function(i) {
      triggers.push(i);
    });
    
    var matcher = new RegExp("(?:^|;)\\s*(" + triggers.join("|") + ")$", 'i');
    return this.filter('input[type=text]').each(function() {  
      $(this)
        .attr('autocomplete', 'off')
        .autocomplete([])
        .keypress(function(e) {
          var matched = ($(this).val() + String.fromCharCode(e.which)).match(matcher);
          if(matched) {
            var o = {
              formatMatch: function(name, i, max) {
                return matched[1] + " " + name;
              },
              formatResult: function(name) {
                return matched[1] + " " + name;
              },
              data: data[matched[1]]
            }
            options = $.extend(options, o);
            $(this)
              .setOptions(options);
          }
        });
      
      return;
      
      //make the input box into an autocomplete for the select items
      $input.autocomplete(data, options);
      
      //make the result handler set the selected item in the select list
      $input.result(function(event, selected_item, formatted) {
        $($this.find('option[value=' + selected_item.value + ']')[0]).attr('selected', true);
      });
      
      $input.blur(function() {
        if ($input.val() == '') {
          $($this.find('option[value=]')[0]).attr('selected', true)
        }
      })

      //set the initial text value of the autocomplete input box to the text node of the selected item in the select control
      $selected = $this.find('[selected]')
      if ($selected) {
        if ($selected.val() == '') {
          $input.addClass('labeled').focus(function() {
            $(this).val('').removeClass('labeled')
          })
        }
        $input.val($selected.text())
      }
      
      
      //normally, you'd hide the select list but we won't for this demo
      $this.hide();
    });
  };      
  
})(jQuery);