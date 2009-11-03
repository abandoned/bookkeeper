Feature: Rules
  In order to keep the company in order
  As a bookkeeper
  I want to be able to manage rules that match transactions
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And I have a Bank Account account descending from Assets, Current Assets, Bank Accounts
    And I have a Shipping Expenses account descending from Expenses
    And the following person records:
      | name                | is_self |
      | Paper Cavalier, LLC | true   |
      | US Postal Service   | false   |
    
  Scenario: Set up a match rule
    Given I am on the Bank Account account page
    When I follow "Rules"
    And I follow "New match rule"
    And I fill in "Description matcher" with "US Postal Service"
    And I select "No" from "Debit"
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "Shipping Expenses" from "Matching account"
    And I press "Submit"
    Then I should see "Successfully created match rule."
    And I should see "US Postal Service"
    
  Scenario: Match an existing rule when set up
    Given I am on the Bank Account account page
    When I follow "Rules"
    And I follow "New match rule"
    And I fill in "Description matcher" with "US Postal Service"
    And I select "No" from "Debit"
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "Shipping Expenses" from "Matching account"
    And I press "Submit"
    Then I go to the Bank Account account page
    And I follow "Transactions"
    And I follow "New transaction"
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I fill in "Total Amount" with "-20"
    And I select "USD" from "Currency"
    And I fill in "Description" with "US Postal Service charge"
    And I press "Submit"
    Then I should see "US Postal Service charge"
    And I should see "-20.0"
    And I should not see "Match transaction"