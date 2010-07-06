Feature: Currency Conversion
  In order to do bookkeeping
  As a bookkeeper
  I want to be able to handle currency conversion gains and losses
  
  Background:
    Given an account "Currency Conversion" exists with name: "Currency Conversion", type: "CurrencyConversion"
    And I am Awesome Bakery and Flour Corp is my supplier
    And a ledger_item "t1" exists with total_amount: -100, currency: "EUR", account: account "Revenue", transacted_on: "2009/01/30", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    And a ledger_item "t2" exists with total_amount: 100, currency: "EUR", account: account "Currency Conversion", transacted_on: "2009/01/30", sender: contact "Flour Corp", recipient: contact "Awesome Bakery"
    And ledger_item "t1" and ledger_item "t2" are matched
    And a ledger_item "t3" exists with total_amount: 110, currency: "USD", account: account "Bank Account", transacted_on: "2009/01/30", sender: contact "Flour Corp", recipient: contact "Awesome Bakery"
    And a ledger_item "t4" exists with total_amount: -110, currency: "USD", account: account "Currency Conversion", transacted_on: "2009/01/30", sender: contact "Awesome Bakery", recipient: contact "Flour Corp"
    And ledger_item "t3" and ledger_item "t4" are matched
    And I am logged in

  Scenario: FX Loss
    Given the USD to EUR rate is 1.2 on "2008-01-01"
    When I go to path "/reports/income-statement"
    Then I should see "Total Currency Conversion"
    And I should see "$10.00"

  Scenario: FX Gain
    Given the USD to EUR rate is 1.0 on "2008-01-01"
    When I go to path "/reports/income-statement"
    Then I should see "Total Currency Conversion"
    And I should see "CR $10.00"