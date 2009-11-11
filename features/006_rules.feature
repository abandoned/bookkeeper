Feature: Rules
  In order to keep the company in order
  As a bookkeeper
  I want to be able to manage rules that match ledger items
  
  Background:
    Given I am logged in as bookkeeper
    And I have a default ledger set up
    And I have a Current Assets account descending from Assets
    And I have a Bank Accounts account descending from Current Assets
    And I have a Bank Account account descending from Bank Accounts
    And I have a Shipping Expenses account descending from Expenses
    And the following person records:
      | name                | is_self |
      | Paper Cavalier      | true    |
      | US Postal Service   | false   |
    
  Scenario: Set up a match rule
    Given I am on the Bank Account account page
    When I follow "Rules"
    And I follow "New rule"
    And I fill in "Regexp" with "US Postal Service"
    And I select "No" from "Debit"
    And I select "Paper Cavalier" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "Shipping Expenses" from "Matching account"
    And I press "Submit"
    Then I should see "Successfully created rule."
    And I should see "US Postal Service"
    
  Scenario: Match an existing rule when set up
    Given I am on the Bank Account account page
    When I follow "Rules"
    And I follow "New rule"
    And I fill in "Regexp" with "US Postal Service"
    And I select "No" from "Debit"
    And I select "Paper Cavalier" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "Shipping Expenses" from "Matching account"
    And I press "Submit"
    And I go to the Bank Account account page
    And I follow "View ledger items"
    And I follow "New ledger item"
    And I select "Paper Cavalier" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I fill in "Total Amount" with "-20"
    And I select "USD" from "Currency"
    And I fill in "Description" with "US Postal Service charge"
    And I press "Submit"
    Then I should see "US Postal Service charge"
    And I should see "-20.0"
    And I should not see "Match"