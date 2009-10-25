Feature: Match rules
  In order to keep the company ledger in order
  As a bookkeeper
  I want to be able to manage rules to match ledger items
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And I have a Bank Account ledger account descending from Assets, Current Assets, Bank Accounts
    And I have a Shipping Expenses ledger account descending from Expenses
    And the following ledger person records:
      | name                | is_self |
      | Paper Cavalier, LLC | true   |
      | US Postal Service   | false   |
    
  Scenario: Set up a match rule
    Given I am on the Bank Account ledger account page
    When I follow "Match rules"
    And I follow "New match rule"
    And I fill in "Description matcher" with "US Postal Service"
    And I select "No" from "Debit"
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "Shipping Expenses" from "Matching ledger account"
    And I press "Submit"
    Then I should see "Successfully created match rule."
    And I should see "US Postal Service"