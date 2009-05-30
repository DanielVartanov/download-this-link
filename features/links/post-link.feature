Feature: Posting a link
  In order to let users tell application which files to download
  Users should have opportunity to post new links

  Scenario: User sees "Post link" form on the main page
    When I go to main page
    Then I should see "Post link"

  Scenario: User posts valid link
    Given I go to main page
    When I fill in "URL" with "http://example.com"
    And I press "Post link"
    Then I should not be redirected
    And I should see a link to "http://example.com"
    And I should see "queued"

  Scenario: User tries to post invalid link
    Given I go to main page
    When I fill in "URL" with "bla-bla-bla"
    And I press "Post link"
    Then I should not be redirected
    And I should see "Wrong URL!"
    And I should not see a link to "http://example.com"
    And I should not see "queued"

  Scenario: User tries to post blank link
    Given I go to main page
    When I fill in "URL" with ""
    And I press "Post link"
    Then I should not be redirected
    And I should see "Wrong URL!"
    And I should not see a link to ""
    And I should not see "queued"

  Scenario: User posts link without protocol
    Given I go to main page
    When I fill in "URL" with "example.com"
    And I press "Post link"
    Then I should not be redirected
    And I should see a link to "http://example.com"
    And I should see "queued"