Feature: Match Existing Ledger Items
  In order to keep the company in order
  As a bookkeeper
  I want to be able to reconcile by matching existing ledger items
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And the following person records:
      | id | name              | is_self |
      | 1  | Paper Cavalier    | true    |
      | 2  | US Postal Service | false   |
    And the following match record:
      | id |
      | 1  |
    And the following ledger_item records:
      | id | sender_id | recipient_id | match_id | total_amount |
      | 1  | 1         | 2            | 1        | -100.0       |
      | 2  | 2         | 1            | 1        | 100.0        |
  
  Scenario: View matched ledger items
    Given I am on the list of ledger_items
    When I follow "View Matches"
    Then I should see "Matches"
    And I should see "Paper Cavalier"
    And I should see "US Postal Service"
    
  
  Scenario: Match two ledger items and reconcile
  
  Scenario: Match three ledger items and reconcile
  
  Scenario: Fail to edit a ledger item that is matched