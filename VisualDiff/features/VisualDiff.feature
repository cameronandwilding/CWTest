@javascript
Feature: <<<PROJECT NAME>>>
  In order to test visual responsiveness of the site
  As an anonymous user
  I need to take entire page screenshots of set widths

Scenario: Testing homepage at various sizes
	Given I go to "/"
	And I set the browser window size to "320" x "768"
    And I set the browser window size to "580" x "768"
    And I set the browser window size to "800" x "768"
    And I set the browser window size to "1400" x "768"