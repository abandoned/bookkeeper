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
    Then I should see "You are logged in" within "#flash_notice"
    
  Scenario: Require login on list of accounts
    When I go to path "/accounts"
    Then I should be on path "/user_session/new"
    
  Scenario: Require login on list of people
    When I go to path "/people"
    Then I should be on path "/user_session/new"
  
  Scenario: Require login on list of ledger items
    When I go to path "/ledger_items"
    Then I should be on path "/user_session/new"
  
  Scenario: Require login on list of mappings
    When I go to path "/mappings"
    Then I should be on path "/user_session/new"
  
  Scenario: Require login on list of rules
    When I go to path "/accounts/1/rules"
    Then I should be on path "/user_session/new"