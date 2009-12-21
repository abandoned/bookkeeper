Feature: Authentication
  In order to keep the company books in order
  As a user
  I want to authenticate myself
  
  Scenario: Log in
    Given a user: "bookkeeper" exists with login: "bookkeeper", password: "secret"
    When I go to path "/user_session/new"
    And I fill in "Username" with "bookkeeper"
    And I fill in "Password" with "secret"
    And I press "Log in"
    Then I should see "You are logged in" within "#flash_success"
  
  Scenario Outline: Require login on resource
    When I go to path "<path>"
    Then I should be on path "/user_session/new"
  
  Examples:
      | path              |
      | /accounts         |
      | /contacts         |
      | /ledger_items     |
      | /mappings         |
      | /accounts/1/rules |
