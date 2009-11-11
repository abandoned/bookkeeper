Given /^I have the following ledger_item records? in (.*):$/ do |account_name, table|
  table.hashes.each do |hash|
    account = Account.find_by_name(account_name)
    Factory(:ledger_item, { :account => account }.merge(hash))
  end
end
