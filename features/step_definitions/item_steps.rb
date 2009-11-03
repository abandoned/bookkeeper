Given /^I have the following transaction records? in (.*):$/ do |account_name, table|
  table.hashes.each do |hash|
    account = Account.find_by_name(account_name)
    Factory(:transaction, { :account => account }.merge(hash))
  end
end
