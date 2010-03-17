Feature: Rules
  In order to do bookkeeping
  As a user
  I want to be able to manage rules that match transactions
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have bought some flour and have paid a utility bill
    And I am logged in
    
  Scenario: Set up a rule
    Given I am on the show page for account "Bank Account"
    When I follow "Set up rules"
    And I follow "Create rule"
    And I fill in "Matched description" with "flour purchased"
    And I uncheck "Matched debit"
    And I select "Awesome Bakery" from "New sender"
    And I select "Flour Corp" from "New recipient"
    And I select "Flour" from "New account"
    And I press "Create rule"
    Then a rule should exist with matched_description: "flour purchased", account: account "Bank Account"
  
  Scenario: Rule matches transaction by description
    Given a rule exists with account: account "Bank Account", matched_description: "organic", matched_debit: false, new_sender: contact "Awesome Bakery", new_recipient: contact "Flour Corp", new_account: account "Flour"
    And I am on path "/transactions"
    When I follow "Create transaction"
    And I fill in "Total amount" with "-200"
    And I select "USD" from "Currency"
    And I select "Bank Account" from "Account"
    And I fill in "Description" with "Organic flour purchased"
    And I press "Create transaction"
    Then 1 matches should exist
    And a ledger_item should exist with sender: contact "Awesome Bakery", recipient: contact "Flour Corp", total_amount: -200, account: account "Bank Account", match: that match
    And a ledger_item should exist with sender: contact "Flour Corp", recipient: contact "Awesome Bakery", total_amount: 200, account: account "Flour", match: that match
  
  Scenario: Rule matches transaction by contacts
    Given a rule exists with account: account "Bank Account", matched_sender: contact "Awesome Bakery", matched_recipient: contact "Utility Co", matched_debit: false, new_account: account "Utility"
    And I am on path "/transactions"
    When I follow "Create transaction"
    And I fill in "Total amount" with "-200"
    And I select "USD" from "Currency"
    And I select "Bank Account" from "Account"
    And I select "Awesome Bakery" from "Sender"
    And I select "Utility Co" from "Recipient"
    And I press "Create transaction"
    Then 2 matches should exist
    And a ledger_item should exist with sender: contact "Utility Co", recipient: contact "Awesome Bakery", total_amount: 200, account: account "Utility"
  
  Scenario: Rule applies to CSV import
    Given a contact "Bank" exists
    And an account "Citi Account" exists with name: "Citi Account", parent: account "Assets"
    And a rule exists with account: account "Citi Account", matched_description: "SERVICE CHARGE", matched_debit: false, new_sender: contact "Flour Corp", new_recipient: contact "Bank", new_account: account "Expenses"
    And a mapping exists with name: "Citi", currency: "USD", date_row: 1, total_amount_row: 3, description_row: 2, has_title_row: false, day_follows_month: true, reverses_sign: false
    And I am on the show page for account: "Citi Account"
    When I follow "Import transactions"
    And I fill in "Ending balance" with "19427.51"
    And I select "Citi" from "Mapping"
    And I attach the file "spec/fixtures/citi-sample.csv" to "File"
    And I press "Import transactions"
    Then 6 matches should exist
    