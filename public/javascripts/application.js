$(document).ready(function() {
  
  // Obesify search
  $("#search label, #search input[type=submit]").hide();
  $input = $("#search input[type=text]");
  if ($input.val() == "") {
    $input
      .addClass("labeled")
      .val($input.prev().html())
      .bind('focus.label', function() {
        $(this)
          .val("")
          .removeClass("labeled");
      })
      .bind("blur.unbindLabel", function() {
        $(this)
          .unbind("focus.label")
          .unbind("blur.unbindLabel");
      })
      .obesify(data);
  }
  
  $('select.autocomplete').select_autocomplete();
    
  var copy_row = function(row) {
    var new_id = new Date().getTime();
    row.after(ledger_item.replace(/NEW_RECORD/g, new_id))
    var next_row = row.next('tr')
    
    row.find('td').each(function() {
      var index_in_row = row.children().index($(this))
      $(this).find('select').map(function() {
        var index_in_parent = $(this).parent().children().index($(this))
        var default_value = $(this).val()
        next_row.find('td:eq(' + (index_in_row) + ') select:eq(' + (index_in_parent) + ')').val(default_value)
      })
    })
    next_row.find('select.autocomplete').select_autocomplete();
  }
  
  $('form table a.add_row').live('click', function(ev) {
    copy_row($(this).closest('tr'))
    ev.preventDefault();
  })
  
  $('form table tbody tr:last input:last').live('keydown', function(ev) {
    if (ev.which == 9) {
      copy_row($(this).closest('tr'))
    }
    ev.preventDefault()
  })
  
  $('form table a.swap_columns').live('click', function(ev) {
    var td = $(this).closest('td')
    var a = td.prev('td').find('input')
    var b = td.next('td').find('input')
    var v = a.val()
    a.val(b.val())
    b.val(v)
  })
  
  // Strip unnecessary attributes from search gets
  $('#search').find('input, select').removeAttr('disabled')
  $('#search').submit(function() {
    $(this).find('input, select').map(function() {
      if ($.trim($(this).val()) == '') {
        $(this).attr('disabled', 'disabled')
      }
    })
  })
    
  // Calculate total on new ledger item form
  $('form#new_ledger_item table').prepend('<tfoot><tr><td class="small" id="grand-total"></td></tr></tfoot>')
  
  $('form#new_ledger_item').map(function() {
    $(this).find('td input.total-amount').live('change', function() {
      var total = 0
      $('form#new_ledger_item').find('td input.total-amount').each(function() {
        total += parseFloat($(this).val())
      })
      $('#grand-total').html(Math.round(total * 100) / 100)
    })
  })
})
