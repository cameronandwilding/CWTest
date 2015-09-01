Feature: PROJECT NAME
  In order to (to what?)
  As a (as a what?)
  I need (what do you need?)

  Rules:
  - Rule 1
  - Rule 2


############################################################################################################
#   LOGIN
############################################################################################################

  @api @regression @smoke @login
  Scenario: Login with no username or password
    Given I am on "/user"
    When I press "Log in"
    Then the following error messages are displayed:
      | ERROR MESSAGE               |
      | Username field is required. |
      | Password field is required. |
    And the following error messages are not displayed:
      | ERROR MESSAGE                                                                 |
      | Sorry, unrecognized username or password                                      |
      | Unable to send e-mail. Contact the site administrator if the problem persists |

  @api @regression @login
  Scenario: Error messages - login with no username
    Given I am on "/user"
      And I fill in "name" with "name"
    When I press "Log in"
    Then the following error messages are displayed:
      | ERROR MESSAGE                                                                  |
      | Password field is required.                                                    |
      | Sorry, unrecognized username or password. Have you forgotten your password?    |
    And the following error messages are not displayed:
      | ERROR MESSAGE                                                                  |
      | Username field is required.                                                    |
      | Unable to send e-mail. Contact the site administrator if the problem persists  |

  @api @regression @login
  Scenario: Error messages - login with no password
    Given I am on "/user"
      And I fill in "pass" with "password"
    When I press "Log in"
    Then I can see the error message containing "Username field is required."
      And I cannot see the error message containing "Password field is required."

  @api @regression @login
  Scenario: Login with invalid username and password
    Given I am on "/user"
      And I fill in "name" with "name"
      And I fill in "pass" with "password"
    When I press "Log in"
    Then the following error messages are displayed:
      | ERROR MESSAGE               |
      | Sorry, unrecognized username or password. Have you forgotten your password? |


############################################################################################################
#   ROLES & PERMISSIONS
#   - Anonymous User
#   - Administrator
#   - ...
#   - ...
############################################################################################################

  @api @regression @roles
  Scenario: Verify all user types
    Given users:
      | name       | mail            | roles         |
      | Admin User | admin@behat.com | administrator |
     #| Firstname Lastname | email           | role |
     #| Firstname Lastname | email           | role |

######################
###   ANONYMOUS USER
######################

  @api @regression @smoke @roles
  Scenario: Verify Anonymous User page access
    Given I am not logged in
    Then I should get the following HTTP status responses:
      | /            | 200 |
      | /user        | 200 |
      | /node        | 200 |
      | /node/add    | 403 |
      | /user/logout | 403 |


######################
###  ADMINISTRATOR
######################

  @api @regression @roles
  Scenario: Verify Admin user page access
    Given I am logged in as a user with the administrator role
    Then I should get the following HTTP status responses:
      | /              | 200 |
      | /admin/content | 200 |
      | /admin/people  | 200 |
      | /node          | 200 |
      | /node/add      | 200 |
      | /user          | 200 |
      | /user/logout   | 200 |

  @api @regression @roles
  Scenario: Verify Admin homepage options
    Given I am logged in as a user with the administrator role
      And am on "/user"
    Then I should see the link View
      #And I can see the link View in the content region
      #And I can see the link View in the content region


############################################################################################################
#  CONTENT PAGE FIELDS - verify the fields present for a content type.
#   - Page
#   - ...
#   - ...
############################################################################################################

  @api @regression @smoke @fields
  Scenario: Verify Page content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/page"
      #And I wait for the page to complete loading
      And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                                                                  |
      | id         | cke_edit-body-und-0-value                                              |
      | name       | title                                                                  |
      | label      | Provide a menu link                                                    |
      | class      | summary                                                                |
      | button     | Save                                                                   |
      | xpath      | //*[@id='page-node-form']//*[text()[contains(.,'Publishing options')]] |


############################################################################################################
#  CONTENT TYPES - verify the content types available.
#   - Page
#   - ...
#   - ...
############################################################################################################

  @api @regression @smoke @content
  Scenario: Verify all of the content types that can be created
    Given I am logged in as a user with the administrator role
    When I am on "/node/add"
    Then I should see the link Page
      #And I should see the link
      #And I should see the link
      #And I should see the link
      #And I should see the link


############################################################################################################
#  CONTENT CREATE - verify content types can be created.
#   - Page
#   - ...
#   - ...
############################################################################################################

  @api @regression @content
  Scenario: Create Page content type
    Given I am logged in as a user with the administrator role
      And I am viewing my Page content with the title "Page - created via Behat"


############################################################################################################
#  CONTENT EDIT - verify content types can be edited.
#   - Page
#   - ...
#   - ...
############################################################################################################

  @api @regression @smoke @content
  Scenario: Edit Page content type
    Given I am logged in as a user with the administrator role
      And I should be able to edit a Page content


############################################################################################################
#  CONTENT VALIDATION - verify the validation messages for a content type.
#   - Page
#   - ...
#   - ...
############################################################################################################

  @api @regression @smoke @content
  Scenario: Validation messages for the Page content type
    Given I am logged in as a user with the administrator role
    When I am on "node/add/page"
      And I save
    Then the following error messages are displayed:
      | ERROR MESSAGE            |
      | Title field is required. |


############################################################################################################
#  VERIFY ASSETS - verify the assets for a page.
#   - Links
#   - Meta
#   - Image
#   - Script
#   - Hyperlink
#
#  On the following pages:
#   - Homepage
#   - TBC
############################################################################################################

  @api @regression @smoke @assets
  Scenario: Verify the Link assets for the Homepage page
    Given I am not logged in
    When I am on the homepage
    And I get the HTML of the page
    Then I verify the Link assets
    And I verify the Meta assets
    And I verify the Image assets
    And I verify the Script assets
    And I verify the Hyperlink assets


  @api @scrape
  Scenario: Screen scrape
    Given I am logged in as a user with the administrator role
    Given screen scrape '/node/add/article'



############################################################################################################
#  FUTURE IDEAS
#   - Create a generic tests to cover <script> injections in WYSIWYG.
#        - see EIL-586 and http://www.domxss.com/domxss/01_Basics/05_jquery_html.html?614298498.
############################################################################################################