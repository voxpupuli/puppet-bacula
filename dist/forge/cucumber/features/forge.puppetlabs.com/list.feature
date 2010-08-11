Feature: forge.puppetlabs.com
  It should be up
  And I should be able to click on All Modules

  Scenario: Clicking on All Modules
    When I go to http://forge.puppetlabs.com
    And I follow "All Modules"
    Then I should see "All Modules"

