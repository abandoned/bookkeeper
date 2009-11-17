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
    And I fill in "Regexp" with "Consumption"
    And I select "No" from "Debit"
    And I select "Self" from "Sender"
    And I select "Other" from "Recipient"
    And I select "Expenses" from "Matching account"
    And I press "Submit"
    Then I should see "Successfully created rule" within "#flash_notice"
    And a rule should exist with regexp: "Consumption", account: account "Bank A/C"
  
  @tag
  Scenario: Match an existing rule when set up
    Given a rule exists with account: account "Bank A/C", regexp: "Consumption", debit: false, sender: contact "Self", recipient: contact "Other", matching_account: account "Expenses"
    When I go to the show page for account "Bank A/C"
    And I follow "View ledger items"
    And I follow "New ledger item"
    And I select "Self" from "Sender"
    And I select "Other" from "Recipient"
    And I fill in "Total Amount" with "-20"
    And I select "USD" from "Currency"
    And I fill in "Description" with "Consumption"
    And I press "Submit"
    Then I should see "Successfully created ledger item" within "#flash_notice"
    And 1 matches should exist
    And a ledger_item should exist with sender: contact "Other", recipient: contact "Self", total_amount: 20, account: account "Expenses"