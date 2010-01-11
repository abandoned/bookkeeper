Feature: Delete matches
  In order to take care of my accounting needs
  As a user
  I want to be able to delete erroneous matches
  
  Background:
    Given I am logged in
    And I have a default ledger set up
    And I have a double entry for a beverage purchase
    
  Scenario: Delete match
    Given I am on path "/matches/1"
    When I follow "Delete match"
    Then I should see "Successfully deleted match."
    And a match should not exist
    And a ledger_item "Coffee" should exist with match_id: nil
    And a ledger_item "Purchase" should exist with match_id: nil
    And I should see a button called "Match"