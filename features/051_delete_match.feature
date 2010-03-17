Feature: Delete matches
  In order to do bookkeeping
  As a user
  I want to be able to delete erroneous matches
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have a double entry for a flour purchase from Flour Corp
    And I am logged in
    
  Scenario: Delete match
    Given I am on path "/matches/1"
    When I follow "Delete match"
    Then I should see "Successfully deleted match."
    And a match should not exist
    And a ledger_item "Transaction 6" should exist with match_id: nil
    And a ledger_item "Transaction 7" should exist with match_id: nil