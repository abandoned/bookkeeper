Feature: Rules
  In order to keep the company in order
  As a user
  I want to be able to manage rules that match ledger items
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And an account "Bank A/C" exists with name: "Bank A/C", parent: account "Assets"
    And a contact "Self" exists with name: "Self"
    And a contact "Other" exists with name: "Other"
    
  Scenario: Set up a match rule
    Given I am on the show page for account "Bank A/C"
    When I follow "Rules"
    And I follow "New rule"
    And I fill in "Matched Description" with "Consumption"
    And I select "No" from "Matched Debit"
    And I select "Self" from "New Sender"
    And I select "Other" from "New Recipient"
    And I select "Expenses" from "New account"
    And I press "Submit"
    Then I should see "Successfully created rule" within "#flash_notice"
    And a rule should exist with matched_description: "Consumption", account: account "Bank A/C"
  
  Scenario: Match an existing rule when set up
    Given a rule exists with account: account "Bank A/C", matched_description: "Consumption", matched_debit: false, new_sender: contact "Self", new_recipient: contact "Other", new_account: account "Expenses"
    When I go to the show page for account "Bank A/C"
    And I follow "View ledger items"
    And I follow "New ledger item"
    And I select "Self" from "ledger_items_0_sender_id"
    And I select "Other" from "ledger_items_0_recipient_id"
    And I fill in "ledger_items_0_total_amount" with "-20"
    And I select "USD" from "ledger_items_0_currency"
    And I fill in "ledger_items_0_description" with "Consumption"
    And I press "Submit"
    Then 1 matches should exist
    And a ledger_item should exist with sender: contact "Other", recipient: contact "Self", total_amount: 20, account: account "Expenses"
  
  Scenario: Apply a rule to a new ledger item imported via a CSV file
    Given a rule exists with account: account "Bank A/C", matched_description: "SERVICE CHARGE", matched_debit: false, new_sender: contact "Other", new_recipient: contact "Self", new_account: account "Expenses"
     And a mapping exists with name: "Citi", currency: "USD", date_row: 1, total_amount_row: 3, description_row: 2, has_title_row: false, day_follows_month: true, reverses_sign: false
      And I am on the show page for account: "Bank A/C"
    When I follow "Import Ledger Items"
      And I fill in "Ending Balance" with "19427.51"
      And I select "Citi" from "Mapping"
      And I attach the file at "spec/fixtures/citi-sample.csv" to "File"
      And I press "Upload file"
    Then I should see "View matches"
      And a ledger_item should exist with description: "SERVICE CHARGE"
      And that ledger_item should be matched
    