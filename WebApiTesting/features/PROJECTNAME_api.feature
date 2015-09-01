Feature: PROJECT NAME
  In order to (to what?)
  As a (as a what?)
  I need (what da you need?)

############################################################################################################
#   A series of API test scenarios that will ensure a site is running properly
############################################################################################################

  @webapi
  Scenario: Basic GET request
      When I send a GET request to "/user"
      Then the response code should be 200
        And the response should contain "Username"
        And the response should contain "Password"
        And the response should contain "Log in"

  @webapi
  Scenario: Basic POST request
    When I send a POST request to "/user" with form data:
      """
      name=admin&pass=password&form_build_id=form-aPKztzpVPQ90Ne-IpAkGtMtmI69UZH3O4AVo_1Xj4iY&form_id=user_login&op=Log+in
      """
    And the response code should be 200
    And the response should contain "Log out"

  @webapi
  Scenario: Basic JSON validation test
    When I send a GET request to "/debates/test/create/bundle"
    Then the response code should be 200
    And the response should contain json:
    """
        [{
        "sponsor": "value",
        "key": "value"
        },
        {
        "key": "value",
        "key": "value"
        }]
        """

  @api2
  Scenario: Basic JSON check
    When I send a GET request to "/debates/test/create/bundle"
    Then the response code should be 200
      And the response should contain json:
      """
        {
        "sponsor": "8500",
        "guest_statement": "8513",
        "phase_opening": "8504",
        "phase_rebuttal": "8508",
        "phase_closing": "8512",
        "debate": "8517"
        }
        """


  @api7
  Scenario: Basic JSON check
    When I send a GET request to "/api/v1/issue/EU/json"
    Then the response code should be 200
    And the response should contain json:
    """
        [{
        "issueDate": "2015-08-02",
        "type": "weekend",
        "title": "It’s the weekend",
        "message": "The next issue will be published on Monday."
        }]
        """


  @api4
    Scenario: Basic POST request
    Given I set header "Connection" with value "keep-alive"
    And I set header "Content-Type" with value "application/x-www-form-urlencoded"
      Given I send a POST request to "/user" with values:
        | name    | admin      |
        | pass    | password   |
        | form_id | user_login |
        | op      | Log in     |
      And print response
      Given I send a GET request to "/users/admin"
      Then the response code should be 200

  @api8
  Scenario: Basic POST request
    #Given I am authenticating as "candw" with "biscuits" password
    #Given I set header "Connection" with value "keep-alive"
    And I set header "Content-Type" with value "application/x-www-form-urlencoded"
    #And I set header "Content-Length" with value "53"
    #And I set header "Host" with value "debates.local"
    #And I set header "User-Agent" with value "Apache-HttpClient/4.2.6 (java 1.5)"
    When I send a POST request to "/user" with body:
    """
    name=admin1&pass=password&form_id=user_login&op=Log+in
    """
    And the response should contain "Sorry, unrecognized username or password."

  @api9
  Scenario: Basic POST request
    #Given I am authenticating as "candw" with "biscuits" password
    #Given I set header "Connection" with value "keep-alive"
        And I set header "Content-Type" with value "application/x-www-form-urlencoded"
    And I send a GET request to "/user/logout"
    And I set header "Content-Type" with value "application/x-www-form-urlencoded"
    #And I set header "Content-Length" with value "53"
    #And I set header "Host" with value "debates.local"
    #And I set header "User-Agent" with value "Apache-HttpClient/4.2.6 (java 1.5)"
    When I send a POST request to "/user" with body:
    """
    name=admin&pass=password&form_id=user_login&op=Log+in
    """
    And print response

  @webapi1
  Scenario: Basic POST request
    And I set header "Content-Type" with value "application/x-www-form-urlencoded"
    When I send a POST request to "/user" with form data:
    """
      name=admin&pass=password&form_id=user_login&op=Log+in
      """
    And print response