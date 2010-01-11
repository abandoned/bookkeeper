Feature: Rules
  In order to take care of my accounting needs
  As a user
  I want to be able to manage rules that match transactions
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
    And a contact "Self" exists with name: "Self"
    And a contact "Other" exists with name: "Other"
    
  Scenario: Set up a rule
    Given I am on the show page for account "Starbux"
    When I follow "Rules"
    And I follow "New rule"
    And I fill in "Matched Description" with "Purchase"
    And I select "No" from "Matched Debit"
    And I select "Self" from "New Sender"
    And I select "Other" from "New Recipient"
    And I select "Expenses" from "New account"
    And I press "Submit"
    Then a rule should exist with matched_description: "Purchase", account: account "Starbux"
  
  Scenario: Rules matches transaction by description
    Given a rule exists with account: account "Starbux", matched_description: "Purchase", matched_debit: false, new_sender: contact "Self", new_recipient: contact "Other", new_account: account "Expenses"
    When I go to the show page for account "Starbux"
    And I follow "View transactions"
    And I follow "Record new transaction"
    And I fill in "ledger_items_0_total_amount" with "-20"
    And I select "USD" from "ledger_items_0_currency"
    And I select "Starbux" from "ledger_items_0_account_id"
    And I fill in "ledger_items_0_description" with "Purchase"
    And I press "Submit"
    Then 1 matches should exist
    And a ledger_item should exist with sender: contact "Self", recipient: contact "Other", total_amount: -20, account: account "Starbux"
    And a ledger_item should exist with sender: contact "Other", recipient: contact "Self", total_amount: 20, account: account "Expenses"
  
  Scenario: Rules matches transaction by contacts
    Given a rule exists with account: account "Starbux", matched_sender: contact "Self", matched_recipient: contact "Other", matched_debit: false, new_account: account "Expenses"
    When I go to the show page for account "Starbux"
    And I follow "View transactions"
    And I follow "Record new transaction"
    And I select "Self" from "ledger_items_0_sender_id"
    And I select "Other" from "ledger_items_0_recipient_id"
    And I select "Starbux" from "ledger_items_0_account_id"
    And I fill in "ledger_items_0_total_amount" with "-20"
    And I select "USD" from "ledger_items_0_currency"
    And I press "Submit"
    Then 1 matches should exist
    And a ledger_item should exist with sender: contact "Other", recipient: contact "Self", total_amount: 20, account: account "Expenses"
  
  Scenario: Apply a rule to a new transaction imported via a CSV file
    Given a rule exists with account: account "Starbux", matched_description: "SERVICE CHARGE", matched_debit: false, new_sender: contact "Other", new_recipient: contact "Self", new_account: account "Expenses"
    And a mapping exists with name: "Citi", currency: "USD", date_row: 1, total_amount_row: 3, description_row: 2, has_title_row: false, day_follows_month: true, reverses_sign: false
    And I am on the show page for account: "Starbux"
    When I follow "Import transactions"
    And I fill in "Ending Balance" with "19427.51"
    And I select "Citi" from "Mapping"
    And I attach the file "spec/fixtures/citi-sample.csv" to "File"
    And I press "Upload file"
    Then a match should exist
    