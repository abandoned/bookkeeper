Feature: Match Existing Ledger Items
  In order to do bookkeeping
  As a user
  I want to view matches
  
  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I am logged in
    
Scenario: View matched ledger items    
  Given I have a double entry for a flour purchase from Flour Corp
  When I go to path "/matches/1"
  Then I should see "Flour"
  And I should see "Bank Account"