Feature: CW Feature
  In order to test any drupal site
  As a mix of users
  I need to run some basic sanity tests scross the entire site


############################################################################################################
#   LOGIN
############################################################################################################

  @api @regression @login
  Scenario: Login with invalid username and password
    Given I am on "/user"
    And I fill in "name" with "name"
    And I fill in "pass" with "password"
    When I press "Log in"
    Then the following login error messages are displayed:
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

######################
###   ANONYMOUS USER
######################

  @api @regression @smoke @roles @bm
  Scenario: Verify Anonymous user page access
    Given I am not logged in
    Then I check the HTTP response code is "200" for "/"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access
    Given I am not logged in
    Then I check the HTTP response code is "200" for "/user/login"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/node/add"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/admin"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/user/logout"


######################
###  ADMINISTRATOR
######################

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access
    Given I am logged in as a user with the administrator role
    When I go to "/admin/content"
    Then I should see text matching "Content"
    And I should see text matching "Administration"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access
    Given I am logged in as a user with the administrator role
    When I go to "/admin/people"
    Then I should see text matching "People"
    And I should see text matching "Administration"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access
    Given I am logged in as a user with the administrator role
    When I go to "/node/add"
    Then I should see text matching "Add content"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access
    Given I am logged in as a user with the administrator role
    When I go to "/user/logout"
    And I go to "/user"
    Then I should see text matching "Log in"


############################################################################################################
#  CONTENT PAGE FIELDS - verify the fields present for a content type.
#   - Page
#   - ...
#   - ...
#   - these will be added to the project specific feature files.
############################################################################################################


############################################################################################################
#  CONTENT TYPES - verify the content types available.
#   - Page
#   - ...
#   - ...
#   - these will be added to the project specific feature files.
############################################################################################################


############################################################################################################
#  CONTENT CREATE - verify content types can be created.
#   - Page
#   - ...
#   - ...
#   - these will be added to the project specific feature files.
############################################################################################################


############################################################################################################
#  CONTENT EDIT - verify content types can be edited.
#   - Page
#   - ...
#   - ...
#   - these will be added to the project specific feature files.
############################################################################################################


############################################################################################################
#  CONTENT VALIDATION - verify the validation messages for a content type.
#   - Page
#   - ...
#   - ...
#   - these will be added to the project specific feature files.
############################################################################################################

