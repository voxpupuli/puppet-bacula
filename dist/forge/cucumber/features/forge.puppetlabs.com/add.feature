Feature: forge.puppetlabs.com
  It should be up
  And I should be able to add a module

  Scenario: Add a Module
    When I go to http://forge.puppetlabs.com
    And I follow "Add a module"
    Then I should see "You need to sign in or sign up before continuing"

