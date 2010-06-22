Feature: Income Statement
  In order to do bookkeeping
  As a bookkeeper
  I want to be able to generate income statements
  
  I deposited US$2000 AND £1000 in the Bank Account, posting against Equity.
  I paid Flour Corp US$500 for flour, taking the money out of the Bank Account.
  I sold US$900 and £250 worth of bread, depositing the proceeds in the Bank Account.

  Background:
    Given I am Awesome Bakery and Flour Corp is my supplier
    And I have conducted some business over the past year
    And the GBP to EUR rate is 0.8 on "2008-01-01"
    And the USD to EUR rate is 1.2 on "2008-01-01"
    And I am logged in

  Scenario: Link to income statement
    When I go to path "/reports/income-statement"
    Then I should see "Income Statement" within "title"

  Scenario: Generate income statement
    Given I am on path "/reports/income-statement"
    When I fill in "From" with "2008-01-01"
    And I fill in "To" with "2008-12-31"
    And I press "Update report"
    Then I should see "CR $775.00" within ".net"

    When I select "GBP" from "Base currency"
    And I press "Update report"
    Then I should see "CR £516.67" within ".net"
