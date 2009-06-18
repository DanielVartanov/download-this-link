Feature: Posting a link
  In order to let users tell application which files to download
  Users should have opportunity to post new links

  Scenario: User sees a link to new link page on the main page
    When I go to main page
    Then I should see a link to "/links/new"

  Scenario: User sees a new link form
    When I go to new link page
    Then I should see "URL"
    And I should see "Добавить ссылку"

  Scenario: User posts valid link
    When I go to new link page
    And I fill in "URL" with "http://example.com"
    And I press "Добавить ссылку"
    Then I should be redirected to links list
    And I should see a link to "http://example.com"
    And I should see "queued"

  Scenario: User tries to post invalid link
    When I go to new link page
    And I fill in "URL" with "bla-bla-bla"
    And I press "Добавить ссылку"
    Then I should not be redirected
    And I should see "Wrong URL!"
    And I should not see a link to "http://example.com"
    And I should not see "queued"

  Scenario: User tries to post blank link
    When I go to new link page
    And I fill in "URL" with ""
    And I press "Добавить ссылку"
    Then I should not be redirected
    And I should see "Wrong URL!"
    And I should not see a link to ""
    And I should not see "queued"

  Scenario: User posts link without protocol
    When I go to new link page
    And I fill in "URL" with "example.com"
    And I press "Добавить ссылку"
    Then I should be redirected to links list
    And I should see a link to "http://example.com"
    And I should see "queued"