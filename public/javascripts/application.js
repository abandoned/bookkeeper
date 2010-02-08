jQuery(document).ready(function() {
  
  // Obesify search
  jQuery("#search label, #search input[type=submit]").hide();
  $input = jQuery("#search input[type=text]");
  if ($input.val() == "") {
    $input
      .addClass("labeled")
      .val($input.prev().html())
      .bind('focus.label', function() {
        jQuery(this)
          .val("")
          .removeClass("labeled");
      })
      .bind("blur.unbindLabel", function() {
        jQuery(this)
          .unbind("focus.label")
          .unbind("blur.unbindLabel");
      })
      .obesify(data);
  }
  
  
  jQuery('select.autocomplete').select_autocomplete();
  
  var copy_row = function(row) {
    var new_id = new Date().getTime();
    row.after(ledger_item.replace(/NEW_RECORD/g, new_id))
    var next_row = row.next('tr')
    
    row.find('td').each(function() {
      var index_in_row = row.children().index(jQuery(this))
      jQuery(this).find('select').map(function() {
        var index_in_parent = jQuery(this).parent().children().index(jQuery(this))
        var default_value = jQuery(this).val()
        next_row.find('td:eq(' + (index_in_row) + ') select:eq(' + (index_in_parent) + ')').val(default_value)
      })
    })
    next_row.find('select.autocomplete').select_autocomplete()
  }
  
  jQuery('form table a.add_row').live('click', function(ev) {
    copy_row(jQuery(this).closest('tr'))
    ev.preventDefault();
  })
  
  jQuery('form table tbody tr:last input:last').live('keydown', function(ev) {
    if (ev.which == 9) {
      copy_row(jQuery(this).closest('tr'))
    }
    ev.preventDefault()
  })
  
  jQuery('form table a.swap_columns').live('click', function(ev) {
    var td = jQuery(this).closest('td')
    var a = td.prev('td').find('input')
    var b = td.next('td').find('input')
    var v = a.val()
    a.val(b.val())
    b.val(v)
  })
  
  // Strip unnecessary attributes from search gets
  jQuery('#search').find('input, select').removeAttr('disabled')
  jQuery('#search').submit(function() {
    jQuery(this).find('input, select').map(function() {
      if ($.trim(jQuery(this).val()) == '') {
        jQuery(this).attr('disabled', 'disabled')
      }
    })
  })
    
  // Calculate total on new ledger item form
  jQuery('form#new_ledger_item table').prepend('<tfoot><tr><td class="small" id="grand-total"></td></tr></tfoot>')
  
  jQuery('form#new_ledger_item').map(function() {
    jQuery(this).find('td input.total-amount').live('change', function() {
      var total = 0
      jQuery('form#new_ledger_item').find('td input.total-amount').each(function() {
        total += parseFloat(jQuery(this).val())
      })
      jQuery('#grand-total').html(Math.round(total * 100) / 100)
    })
  })
})
