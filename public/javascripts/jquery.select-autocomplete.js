(function($) {
 
	$.fn.select_autocomplete = function(options) {
 
		// make sure we have an options object
		options = options || {};
 
		// setup our defaults
		var defaults = { 
			  minChars: 0
			, width: 310
			, matchContains: true
			, autoFill: true
			, formatItem: function(row, i, max) {
				return row.name;
			}
			, formatMatch: function(row, i, max) {
				return row.name;
			}
			, formatResult: function(row) {
				return row.name;
			}
		};
 
		options = $.extend(defaults, options);
 
		return this.each(function() {
 
			//stick each of it's options in to an items array of objects with name and value attributes 
			var $this = $(this),
				data = [],
				$input = $('<input />');
 
			if (this.tagName.toLowerCase() != 'select') { return; }
 
 
			$this.children('option').each(function() {
 
				var $option = $(this);
 
				if ($option.val() != '') { //ignore empty value options
 
					data.push({
						  name: $option.html()
						, value:$option.val()
					});
				}
			});
 
			// insert the input after the select
			$this.after($input);
 
			// add it our data
			options.data = data;
 
			//make the input box into an autocomplete for the select items
			$input.autocomplete(data, options);
 
			$input.bind('keydown', function(e) {
			  if (e.which == 8) {
			    $($this.find('option[value=]')[0]).attr('selected', true);
			  }
			})
			
			//make the result handler set the selected item in the select list
			$input.result(function(event, selected_item, formatted) { 
				$($this.find('option[value=' + selected_item.value + ']')[0]).attr('selected', true);
			});
 
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