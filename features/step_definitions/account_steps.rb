Given /^I have a default ledger set up$/ do
  steps %Q{
    Given an account: "Assets" exists with name: "Assets"
    And an account: "Liabilities" exists with name: "Liabilities"
    And an account: "Equity" exists with name: "Equity"
    And an account: "Income" exists with name: "Income"
    And an account: "Expenses" exists with name: "Expenses"
  }
end


Given /^the following accounts?$/ do |table|
  table.hashes.each do |hash|
    ancestors = hash["name"].split(/ *> */)
    self_name = ancestors.slice!(-1)
    parent = ancestors.inject(Account.find_by_name(ancestors.slice!(0))) do |parent, ancestor|
      parent.children.find_by_name(ancestor) ||
        Factory(:account, { :name => ancestor })
    end
    hash = hash.dup
    hash.merge!({ :parent => parent, :name => self_name })
    parent.children.find_by_name(self_name) || Factory(:account, hash)
  end
end

Given /^there is an? "([^\"]*)" account"$/ do |account_path|
  descent = account_path.split(/ *> */)
  descent.inject(Account.find_or_create_by_name(descent.slice!(0))) do |pool, name|
    pool = pool.find_or_create_by_name(name).children
    break if pool.empty?
  end  
end