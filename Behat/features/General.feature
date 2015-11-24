
Feature: Verify general Turner CMS functionalities
  As a TG Editor or Subeditor
  I want to verify general CMS features
  So that I can verify the Turner CMS is functioning correctly


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
      | name       | mail            | roles |
      | Admin User | admin@behat.com | admin |

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


######################
###  ADMINISTRATOR
######################

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access /admin/content
    Given I am logged in as a user with the admin role
    When I go to "/admin/content"
    Then I should see text matching "Content"
    And I should see text matching "Administration"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access /admin/people
    Given I am logged in as a user with the admin role
    When I go to "/admin/people"
    Then I should see text matching "People"
    And I should see text matching "Administration"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access /node/add
    Given I am logged in as a user with the admin role
    When I go to "/node/add"
    Then I should see text matching "Add content"

  @api @regression @smoke @roles
  Scenario: Verify Admin user page access /user/logout
    Given I am logged in as a user with the admin role
    When I go to "/user/logout"
    And I go to "/user"
    Then I should see text matching "Log in"


############################################################################################################
#  CONTENT TYPES - verify the content types available.
# - Article
# - Boxout
# - Cartoons
# - Headshot
# - interstitial_ad_placeholder
# - Package
# - Picnrun
# - Pugpig Edition
# - Puzzle
# - Section
############################################################################################################

  @api @regression @smoke @content
  Scenario: Verify all of the content types that can be created
    Given I am logged in as a user with the editor role
    When I am on "/node/add"
    Then I should see "Add content" in the ".page-header" element
      And I should see 10 ".node-type-list>dd" elements
      And I should see the text Article
      And I should see the text Boxout
      And I should see the text Cartoons
      And I should see the text Headshot
      And I should see the text interstitial_ad_placeholder
      And I should see the text Package
      And I should see the text Picnrun
      And I should see the text "Pugpig Edition"
      And I should see the text Puzzle
      And I should see the text Section


############################################################################################################
#  CONTENT CREATE - verify content types can be created.
# - Article
# - Boxout
# - Cartoons
# - Headshot
# - interstitial_ad_placeholder
# - Package
# - Picnrun
# - Pugpig Edition
# - Puzzle
# - Section
############################################################################################################

  @api @regression @content
  Scenario: Create Article content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/article"
      And I fill in "edit-field-headline-und-0-value" field with "Article - created by Behat"
      And I press "Save and exit"
    Then I should see "Saved article \"Article - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Boxout content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/boxout"
    And I fill in "edit-title" field with "Boxout - created by Behat"
    And I press "Save"
    Then I should see "Saved boxout \"Boxout - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Cartoon content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/cartoons"
      And I select "Alex" from "edit-field-cartoon-type-und"
      And I press "Save and exit"
    Then I should see "Saved cartoons \"Alex" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Headshot content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/author"
    And I fill in "edit-title" field with "Headshot - created by Behat"
    And I press "Save"
    Then I should see "Saved author \"Headshot - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Placeholder content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/interstitial-ad-placeholder"
    And I fill in "edit-title" field with "Placeholder - created by Behat"
    And I press "Save"
    Then I should see "Saved interstitial_ad_placeholder \"Placeholder - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Package content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/package"
    And I fill in "edit-field-headline-und-0-value" field with "Package - created by Behat"
    And I select "News Package" from "edit-field-package-type-und"
    And I press "Save"
    Then I should see "Saved package \"Package - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Picnrun content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/pic-and-run"
    And I fill in "edit-field-headline-und-0-value" field with "Picnrun - created by Behat"
    And I press "Save and exit"
    Then I should see "Saved pic_and_run \"Picnrun - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Pugpig Edition content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/pugpig-edition"
      And I fill in "edit-field-pugpig-key-und-0-value" field with "PugpigEditionKey-createdbyBehat"
      And I fill in "edit-field-pugpig-title-und-0-value" field with "Pugpig Edition Value- created by Behat"
      And I fill in "edit-field-pugpig-date-und-0-value" field with "2015-12-31"
      And I press "Save"
    Then I should see "Saved pugpig_edition \"Edition" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Puzzle content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/puzzle"
    And I fill in "edit-title" field with "Puzzle - created by Behat"
    And I press "Save"
    Then I should see "Saved puzzle \"Puzzle - created by Behat" in the ".alert-success" element

  @api @regression @content
  Scenario: Create Section content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/section"
    And I select "News Articles" from "edit-field-section-und-0-tid"
    And I press "Save"
    Then I should see "Saved section \"News Articles" in the ".alert-success" element


############################################################################################################
#  CONTENT VALIDATION - verify the validation messages for a content type.
# - Article
# - Boxout
# - Cartoons
# - Headshot
# - interstitial_ad_placeholder
# - Package
# - Picnrun
# - Pugpig Edition
# - Puzzle
# - Section
############################################################################################################

  @api @regression @smoke @validation
  Scenario: Verify Article validation rules
    Given I am logged in as a user with the editor role
    When I go to "/node/add/article"
      And I press "Save and exit"
    Then I should see "Headline field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Boxout content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/boxout"
      And I press "Save"
    Then I should see "Title field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Cartoon content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/cartoons"
      And I press "Save and exit"
    Then I should see "Cartoon type field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Headshot content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/author"
      And I press "Save"
    Then I should see "Name field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Placeholder content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/interstitial-ad-placeholder"
      And I press "Save"
    Then I should see "Title field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Package content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/package"
      And I press "Save"
    Then I should see "Headline field is required." in the ".alert-danger" element
      And I should see "Package type field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Picnrun content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/pic-and-run"
      And I press "Save and exit"
    Then I should see "Headline field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Pugpig Edition content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/pugpig-edition"
      And I press "Save"
    Then I should see "Edition Date field is required." in the ".alert-danger" element
      And I should see "Key field is required." in the ".alert-danger" element
      And I should see "Name field is required." in the ".alert-danger" element
      And I should see "You must provide an edition key." in the ".alert-danger" element
      And I should see "You must provide an edition date." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Puzzle content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/puzzle"
      And I press "Save"
    Then I should see "Title field is required." in the ".alert-danger" element

  @api @regression @validation
  Scenario: Create Section content type
    Given I am logged in as a user with the editor role
    When I go to "/node/add/section"
      And I press "Save"
    Then I should see "Section field is required." in the ".alert-danger" element