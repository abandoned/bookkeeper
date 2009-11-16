Given /^I have a default ledger set up$/ do
  steps %Q{
    Given an account: "Assets" exists with name: "Assets"
    And an account: "Liabilities" exists with name: "Liabilities"
    And an account: "Equity" exists with name: "Equity"
    And an account: "Revenue" exists with name: "Revenue"
    And an account: "Expenses" exists with name: "Expenses"
  }
end
