Then /^there should be (\d+) results$/ do |count|
  all('.ledger_item').size.should == count.to_i
end
