Given /^I have a default ledger set up$/ do
  Given "the following ledger account records", table(%{
    | name        |
    | Assets      |
    | Liabilities |
    | Equity      |
    | Income      |
    | Expenses    |
  })
end

Given /^I have an? (.*) ledger account descending from (.*)$/ do |name, parent_name|
  family_tree = parent_name.split(/,\s*/) << name
  parent = family_tree.inject(nil) do |parent, name|
    if parent.nil?
      LedgerAccount.find_by_name(name, :conditions => "parent_id IS NULL")
    else
      parent.children.find_by_name(name) || Factory(:ledger_account, { :name => name, :parent => parent })
    end
  end
end

Given /^the following ledger accounts?$/ do |table|
  table.hashes.each do |hash|
    ancestors = hash["name"].split(/ *> */)
    self_name = ancestors.slice!(-1)
    parent = ancestors.inject(LedgerAccount.find_by_name(ancestors.slice!(0))) do |parent, ancestor|
      parent.children.find_by_name(ancestor) ||
        Factory(:ledger_account, { :name => ancestor })
    end
    hash = hash.dup
    hash.merge!({ :parent => parent, :name => self_name })
    parent.children.find_by_name(self_name) || Factory(:ledger_account, hash)
  end
end

Given /^there is an? "([^\"]*)" ledger account"$/ do |account_path|
  descent = account_path.split(/ *> */)
  descent.inject(LedgerAccount.find_or_create_by_name(descent.slice!(0))) do |pool, name|
    pool = pool.find_or_create_by_name(name).children
    break if pool.empty?
  end  
end