Feature: Match Existing Ledger Items
  In order to do proper accounting
  As a user
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I am logged in
      And I have a default ledger set up
      And I have a double entry for a beverage purchase
    
  Scenario: View matched ledger items    
    Given a match exists
    When I go to path "/ledger_items"
    Then I should see "Bank Account" within "#ledger_item_1"
    When I follow "Bank Account"
    Then I should see "$3.00"
    And I should see "- $3.00"
    And I should see "Coffee Vendor"
    And I should see "Self"
    And I should see "Bank Account"
    And I should see "Beverages"
      
    
  Scenario: Match two ledger items and reconcile
    Given a ledger_item exists with id: 3, total_amount: -2.00, currency: "USD", account: account "Bank Account", sender: contact "Self", recipient: contact "Coffee Vendor"
    And a ledger_item exists with id: 4, total_amount: 2.00, currency: "USD", account: account "Beverages", sender: contact "Coffee Vendor", recipient: contact "Self"
    When I go to path "/ledger_items"
    And I press "Match" within "#ledger_item_3"
    Then I should see "- $2.00" within "#cart"
    And I should see "Coffee Vendor" within "#cart"
    And I should not see "Reconcile"
    And I should not see a button called "Match" within "#ledger_item_3"
    When I press "Match" within "#ledger_item_4"
    Then I should see "$2.00" within "#cart"
    And I should see "Self" within "#cart"
    When I press "Reconcile"
    Then I should see "Ledger items successfully reconciled"
    And I should not see "Pending Matches"
      
  Scenario: Match three ledger items and reconcile
    Given a ledger_item exists with id: 3, total_amount: -4.00, currency: "USD", account: account "Bank Account", sender: contact "Self", recipient: contact "Coffee Vendor"
    And a ledger_item exists with id: 4, total_amount: 2.00, currency: "USD", account: account "Beverages", sender: contact "Coffee Vendor", recipient: contact "Self"
    And a ledger_item exists with id: 5, total_amount: 2.00, currency: "USD", account: account "Beverages", sender: contact "Coffee Vendor", recipient: contact "Self"
    When I go to path "/ledger_items"
    And I press "Match" within "#ledger_item_3"
    And I press "Match" within "#ledger_item_4"
    And I press "Match" within "#ledger_item_5"
    Then I should see "$2.00" within "#cart"
    And I should see "Coffee" within "#cart"
    And I should see "- $4.00" within "#cart"
    And I should see "Beverages" within "#cart"
    When I press "Reconcile"
    Then I should see "Ledger items successfully reconciled"
    And I should not see "Pending Matches"