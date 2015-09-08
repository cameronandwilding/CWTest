Feature: D8 Show & Tell feature
  In order to verify the functionality of the D8 S&T site
  As a variety of users
  I need run a selection of tests across the entire site

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

######################
###  ADMINISTRATOR
######################

  @api @regression @roles
  Scenario: Verify Admin homepage options
    Given I am logged in as a user with the administrator role
    And am on "/user"
    Then I should see the link Home
    And I should see the link "My account"
    And I should see "View" in the ".is-active" element
    And I should see the link Shortcuts
    And I should see the link Edit


############################################################################################################
#  CONTENT PAGE FIELDS - verify the fields present for a content type.
#   - Article
#   - Basic page
#   - Meetup
#   - Speaker
#   - Talk
############################################################################################################

  @api @regression @smoke @fields
  Scenario: Verify Article content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/article"
    And wait for jquery
    And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                             |
      | id         | edit-title-0-value                |
      | id         | cke_edit-body-0-value             |
      | id         | edit-field-tags-target-id         |
      | id         | edit-actions                      |
      | class      | button js-form-submit form-submit |
      | id         | edit-preview                      |

  @api @regression @fields
  Scenario: Verify Basic page content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/page"
    And wait for jquery
    And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                             |
      | id         | edit-title-0-value                |
      | id         | cke_edit-body-0-value             |
      | class      | button js-form-submit form-submit |
      | id         | edit-preview                      |

  @api @regression @fields
  Scenario: Verify Meetup content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/meetup"
    And wait for jquery
    And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                             |
      | id         | edit-title-0-value                |
      | id         | edit-field-date-0-value-date      |
      | id         | edit-field-date-0-value-time      |
      | id         | edit-field-image-0-upload         |
      | id         | cke_edit-body-0-value             |
      | id         | edit-field-meetup-rsvp-0-uri      |
      | id         | edit-field-meetup-rsvp-0-title    |
      | class      | button js-form-submit form-submit |
      | id         | edit-preview                      |

  @api @regression @fields
  Scenario: Verify Speakers content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/speakers"
    And wait for jquery
    And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                             |
      | id         | edit-title-0-value                |
      | id         | edit-field-image-0-upload         |
      | id         | edit-field-twitter-0-uri          |
      | id         | edit-field-twitter-0-title        |
      | id         | edit-field-linkedin-0-uri         |
      | id         | edit-field-linkedin-0-title       |
      | id         | edit-field-company-name-0-value   |
      | id         | edit-field-position-0-value       |
      | id         | cke_edit-body-0-value             |
      | class      | button js-form-submit form-submit |
      | id         | edit-preview                      |

  @api @regression @fields1
  Scenario: Verify Talks content type fields
    Given I am logged in as a user with the administrator role
    When I am on "node/add/talks"
    And wait for jquery
    And I get the HTML of the page
    Then I verify the following fields are present:
      | IDENTIFIER | FIELD                                  |
      | id         | edit-title-0-value                     |
      | id         | cke_edit-body-0-value                  |
      | id         | edit-field-speaker-0-target-id         |
      | id         | edit-field-speaker-add-more            |
      | id         | cke_edit-field-embedded-slides-0-value |
      | id         | edit-field-video-0-uri                 |
      | id         | edit-field-video-0-title               |
      | id         | edit-field-topic-0-target-id           |
      | id         | edit-field-topic-add-more              |
      | class      | button js-form-submit form-submit      |
      | id         | edit-preview                           |

############################################################################################################
#  CONTENT TYPES - verify the content types available.
#   - Article
#   - Meetup
#   - Basic page
#   - Speakers
#   - Talks
############################################################################################################

  @api @regression @smoke @content
  Scenario: Verify all of the content types that can be created
    Given I am logged in as a user with the administrator role
    When I am on "/node/add"
    Then I should see "Add content" in the ".page-title" element
    Then I should see 5 ".label" elements
    And I should see the text Article
    And I should see the text Meetup
    And I should see the text "Basic page"
    And I should see the text Speakers
    And I should see the text Talks


############################################################################################################
#  CONTENT CREATE - verify the content types can be created.
#   - Article
#   - Meetup
#   - Basic page
#   - Speakers
#   - Talks
############################################################################################################

  @api @regression @content
  Scenario: Create Article content type
    Given I am logged in as a user with the administrator role
    And I am viewing a Article content:
      | title | Article - created via Behat |

  @api @regression @content
  Scenario: Create Meetup content type
    Given I am logged in as a user with the administrator role
    And I am viewing a Meetup content:
      | title | Meetup - created via Behat |

  @api @regression @content
  Scenario: Create Basic page content type
    Given I am logged in as a user with the administrator role
    And I am viewing a "Basic page" content:
      | title | Basic page - created via Behat |

  @api @regression @content
  Scenario: Create Speakers content type
    Given I am logged in as a user with the administrator role
    And I am viewing a Speakers content:
      | title | Speakers - created via Behat |

  @api @regression @content
  Scenario: Create Talks content type
    Given I am logged in as a user with the administrator role
    And I am viewing a Talks content:
      | title | Talks - created via Behat |

############################################################################################################
#  CONTENT CREATE - verify the content types can be edited.
#   - Article
#   - Meetup
#   - Basic page
#   - Speakers
#   - Talks
############################################################################################################



