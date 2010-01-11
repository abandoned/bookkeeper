Feature: Update matched transactions
  In order to take care of my accounting needs
  As a user
  I want to be able to update matched transactions
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have a double entry for a beverage purchase
    
  Scenario: Update transactions
    Given I am on the show page for ledger_item "Purchase"
    When I follow "Edit"
    And I fill in "Description" with "Another expense"
    And I press "Submit"
    Then ledger_item "Coffee" should exist
    And ledger_item "Purchase" should exist
    And the match should exist