Feature: forge.puppetlabs.com
  It should be up
  And I should be able to get to the registration page

  Scenario: Register
    When I go to http://forge.puppetlabs.com
    And I follow "Register"
    Then I should see "Register"

