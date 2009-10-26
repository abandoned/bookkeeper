Feature: Manage Ledger Transactions
  In order to keep the company ledger in order
  As a bookkeeper
  I want to be able to create and manage transactions
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And I have a Bank Account ledger account descending from Assets, Current Assets, Bank Accounts
    And I have a Shipping Expenses ledger account descending from Expenses
    And the following ledger person records:
      | name                | is_self |
      | Paper Cavalier, LLC | true   |
      | US Postal Service   | false   |
    
  Scenario: Create a new credit entry under the Citibank account
    Given I am on the Bank Account ledger account page
    When I follow "Ledger items"
    And I follow "New ledger item"
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I fill in "Total Amount" with "-20"
    And I select "USD" from "Currency"
    And I fill in "Description" with "US Postal Service charge"
    And I press "Submit"
    Then I should see "US Postal Service charge"
    And I should see "-20.0"
    And I should see "Match item"
    
  Scenario: View ledger transactions for a date range
    
  