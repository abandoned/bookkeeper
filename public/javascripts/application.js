$(function() {
  
  //
  // Obesify search
  //
  $('#search input[type=submit]').hide();
  $input = $('#search input[type=text]');
  if (typeof(data) != "undefined") {
    $input.obesify(data);
  }
  
  //
  // Autocomplete
  //
  $('select.autocomplete').select_autocomplete();
  
  //
  // Add a new transaction on multiple_new_ledger_item_path
  //
  var copyLedgerItem = function(currentLedgerItem) {
    var newId = new Date().getTime();
    var nextLedgerItem = $(ledger_item_fields.replace(/NEW_RECORD/g, newId));
    currentLedgerItem.after(nextLedgerItem);
    
    
    nextLedgerItem.find('.autocomplete').select_autocomplete();
     
    // Autofill selects and autocompletes in added transaction
    currentLedgerItem.find('dd select').each(function(ind) {
      var defaultValue = $(this).val();
      nextLedgerItem.find('dd select:eq(' + ind + ')').val(defaultValue);
    });
    
    currentLedgerItem.find('dd .ac_input').each(function(ind) {
      var defaultValue = $(this).val();
      nextLedgerItem.find('dd .ac_input:eq(' + ind + ')').val(defaultValue);
    });
  }
  
  $('form a.add-ledger-item').live('click', function(ev) {
    copyLedgerItem($(this).closest('.new-ledger-item'))
    ev.preventDefault();
  });
  
  //
  // Automatically add new transaction fields when user tabs on last input field
  //
  $('.new-ledger-item input:last').live('keydown', function(ev) {
    if (ev.which == 9) {
      copyLedgerItem($(this).closest('.new-ledger-item'));
    }
    ev.preventDefault();
  });
  
  //
  // Calculate total on new ledger item form
  //
  $('form.new_ledger_items')
    .append('<div id="grand-total"></div>')
    .map(function() {
      $(this).find('input.total-amount').live('change', function() {
        var total = 0
        $('form.new_ledger_items').find('input.total-amount').each(function() {
          total += parseFloat($(this).val());
        });
        $('#grand-total').html('Grand total: ' + Math.round(total * 100) / 100);
      });
    });
});