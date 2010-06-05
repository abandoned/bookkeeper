Feature: Balance Sheet
  In order to do bookkeeping
  As a user
  I want to be able to generate balance sheets
  
  I deposited US$2000 AND £1000 in the Bank Account, posting against Equity.
  I paid Flour Corp US$500 for flour, taking the money out of the Bank Account.
  I sold US$900 and £250 worth of bread, depositing the proceeds in the Bank Account.

  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have conducted some business over the past year
    And the GBP to EUR rate is 0.8 on "2008-01-01"
    And the USD to EUR rate is 1.2 on "2008-01-01"
    And I am logged in

  Scenario: Link to balance sheet
    When I go to path "/reports/balance-sheet"
    Then I should see "Balance Sheet" within "title"

  Scenario: Generate balance sheet
    Given I am on path "/reports/balance-sheet"
    And I fill in "Date" with "2008-12-31"
    And I press "Update report"
    Then show me the page
    Then I should see "$775.00" within ".net"

    When I select "GBP" from "Base currency"
    And I press "Update report"
    Then I should see "£516.67" within ".net"
