Given /^I have a default ledger set up$/ do
  Given "the following account records:", table(%{
    | name        |
    | Assets      |
    | Liabilities |
    | Equity      |
    | Income      |
    | Expenses    |
  })
end

Given /^I have an? (.*) account descending from (.*)$/ do |name, parent_name|
  parent = Account.find_by_name(parent_name)
  Factory(:account, { :name => name, :parent => parent })
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