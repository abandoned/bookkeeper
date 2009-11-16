Feature: Match Existing Ledger Items
  In order to keep the company in order
  As a user
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And a person "Self" exists with name: "Self"
      And a person "Other" exists with name: "Other"
    
  Scenario: View matched ledger items    
    Given a match exists
      And a ledger_item exists with total_amount: "2.99", currency: "USD", account: account "Expenses", sender: person "Self", recipient: person "Other", match: the match
      And a ledger_item exists with total_amount: "-2.99", currency: "USD", account: account "Assets", sender: person "Other", recipient: person "Self", match: the match
    When I go to path "/ledger_items"
    Then I should see "View matches"
    When I follow "View matches"
    Then I should see "$2.99"
      And I should see "- $2.99"
      And I should see "Expenses"
      And I should see "Assets"
      And I should see "Self"
      And I should see "Other"
      
    
  Scenario: Match two ledger items and reconcile
    Given a ledger_item exists with id: 1, total_amount: "2.99", currency: "USD", account: account "Expenses", sender: person "Self", recipient: person "Other"
      And a ledger_item exists with id: 2, total_amount: "-2.99", currency: "USD", account: account "Assets", sender: person "Other", recipient: person "Self"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
    Then I should see "$2.99" within "#cart"
      And I should see "Expenses" within "#cart"
      And I should not see "Save match"
    When I press "Match" within "#ledger_item_2"
    Then I should see "- $2.99" within "#cart"
      And I should see "Assets" within "#cart"
    When I press "Reconcile"
    Then I should see "Ledger items successfully reconciled"
    And I should not see "Matches"
      
  Scenario: Match three ledger items and reconcile
    
  Scenario: Fail to edit a ledger item that is matched