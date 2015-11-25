Feature: CW Feature
  In order to test any drupal site
  As a mix of users
  I need to run some basic sanity tests across the entire site


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

######################
###   ANONYMOUS USER
######################

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access to /user/login
    Given I am not logged in
    Then I check the HTTP response code is "200" for "/user/login"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access to /node/add
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/node/add"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access to /admin
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/admin"

  @api @regression @smoke @roles
  Scenario: Verify Anonymous user page access /user/logout
    Given I am not logged in
    Then I check the HTTP response code is "403" for "/user/logout"


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

