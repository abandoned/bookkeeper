Feature: Match Existing Ledger Items
  In order to do proper accounting
  As a user
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And an account "Starbux" exists with name: "Starbux", parent: account "Assets"
      And an account "Coffee" exists with name: "Coffee", parent: account "Expenses"
      And a contact "Self" exists with name: "Self"
      And a contact "Starbux" exists with name: "Starbux"
    
  Scenario: View matched ledger items    
    Given a match exists
      And a ledger_item exists with total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux", match: the match
      And a ledger_item exists with total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self", match: the match
    When I go to path "/ledger_items"
    Then I should see "View matches"
    When I follow "View matches"
    Then I should see "$2.99"
      And I should see "- $2.99"
      And I should see "Coffee"
      And I should see "Starbux"
      And I should see "Self"
      And I should see "Starbux"
      
    
  Scenario: Match two ledger items and reconcile
    Given a ledger_item exists with id: 1, total_amount: "-2.99", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
      And a ledger_item exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
    Then I should see "- $2.99" within "#cart"
      And I should see "Starbux" within "#cart"
      And I should not see "Reconcile"
      And I should not see a button called "Match" within "#ledger_item_1"
    When I press "Match" within "#ledger_item_2"
    Then I should see "$2.99" within "#cart"
      And I should see "Coffee" within "#cart"
    When I press "Reconcile"
    Then I should see "Ledger items successfully reconciled"
    And I should not see "Matches"
      
  Scenario: Match three ledger items and reconcile
    Given a ledger_item exists with id: 1, total_amount: "-5.98", currency: "USD", account: account "Starbux", sender: contact "Self", recipient: contact "Starbux"
      And a ledger_item exists with id: 2, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self"
      And a ledger_item exists with id: 3, total_amount: "2.99", currency: "USD", account: account "Coffee", sender: contact "Starbux", recipient: contact "Self"
    When I go to path "/ledger_items"
      And I press "Match" within "#ledger_item_1"
      And I press "Match" within "#ledger_item_2"
      And I press "Match" within "#ledger_item_3"
    Then I should see "$2.99" within "#cart"
      And I should see "Coffee" within "#cart"
      And I should see "- $5.98" within "#cart"
      And I should see "Starbux" within "#cart"
    When I press "Reconcile"
    Then I should see "Ledger items successfully reconciled"
    And I should not see "Matches"