Feature: Manage Transactions
  In order to keep the company in order
  As a bookkeeper
  I want to be able to create and manage transactions
  
  Background:
    Given I have a default ledger set up
    And I am logged in as bookkeeper
    And I have a Bank Account account descending from Assets, Current Assets, Bank Accounts
    And I have a Shipping Expenses account descending from Expenses
    And the following person records:
      | name                | is_self |
      | Paper Cavalier, LLC | true   |
      | US Postal Service   | false   |
    
  Scenario: Create a new credit entry under the Citibank account
    Given I am on the list of transactions
    And I follow "New transaction"
    And I select "Bank Account" from "Account"
    And I select "January 1, 2009" as the date
    And I select "Paper Cavalier, LLC" from "Sender"
    And I select "US Postal Service" from "Recipient"
    And I select "USD" from "Currency"
    And I fill in "Total Amount" with "-20"
    And I fill in "Description" with "US Postal Service charge"
    And I press "Submit"
    Then I should see "US Postal Service charge"
    And I should see "Bank Account"
    And I should see "-20.0"
    
  Scenario: View ledger transactions for a date range
    
  