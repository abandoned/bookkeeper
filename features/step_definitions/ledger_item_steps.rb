Given /^I have the following ledger item records? in (.*):$/ do |ledger_account_name, table|
  table.hashes.each do |hash|
    ledger_account = LedgerAccount.find_by_name(ledger_account_name)
    Factory(:ledger_item, { :ledger_account => ledger_account }.merge(hash))
  end
end
