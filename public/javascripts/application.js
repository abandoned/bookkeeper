$(document).ready(function() {
  
  $('select.autocomplete').select_autocomplete();
  
  var copy_row = function(row) {
    var new_id = new Date().getTime();
    row.after(ledger_item.replace(/NEW_RECORD/g, new_id))
    var next_row = row.next('tr').find('select.autocomplete').select_autocomplete()
    next_row.find('select')
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
  $('form.search').find('input, select').removeAttr('disabled')
  
  $('form.search').submit(function() {
    $(this).find('input, select').map(function() {
      if ($.trim($(this).val()) == '') {
        $(this).attr('disabled', 'disabled')
      }
    })
  })
  
  // Dress up the autocomplete select field a bit
  $('form').find('select.autocomplete').map(function() {
    if($(this).val() == '') {
      $(this).next().addClass('labeled').focus(function() {
        $(this).val('').removeClass('labeled');
      });
    }
  });
})
