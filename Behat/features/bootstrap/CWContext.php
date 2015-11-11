<?php
/**
 * @file
 */

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Drupal\DrupalExtension\Context\MinkContext;
use Behat\Gherkin\Node\TableNode;
use Behat\Behat\Context\SnippetAcceptingContext;

/**
 * Class CWHelperContext
 *
 * CWContext contains supporting functions for all Behat projects.
 */
class CWContext extends RawDrupalContext implements SnippetAcceptingContext {

  // Repository Objects constants.
  const MESSAGE_REGION = 'message_region';
  const SUCCESS_MESSAGE_REGION = 'success_message_region';
  const ERROR_MESSAGE_REGION = 'error_message_region';
  const LOGIN_ERROR_MESSAGE_REGION = 'login_error_message_region';

  // Error code.
  const ERROR_CODE = 99;

  // Timeout value in ms.
  const TIMEOUT = 15000;

  // Wait value in ms.
  const WAIT = 1000;

  // Browser width.
  const WIDTH = 1440;

  // Browser height.
  const HEIGHT = 900;

  // Max number of retries.
  const RETRIES = 30;

  // One second.
  const SECOND_TO_SLEEP = 1;

  //  Date format.
  const DATE_FORMAT_CONCISE = "dmY-His";

  /**
   * Parameters inherited from the .yml file
   * @var string
   */
  public $parameters;

  /**
   * Variable strings and numbers
   * @var RandomItems
   */
  public $randomItems;

  /**
   * @var MinkContext
   */
  private $minkContext;

  /**
   * Page HTML
   * @var string
   */
  private $html;

  /**
   * Array of page elements
   * @var array
   */
  public $repoElements;

  /**
   * Array of page elements
   * @var array
   */
  public $pageElements = array();

  /*******************************************************************************
   * Start of INITIALISATION functions.
   *******************************************************************************/

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * Arguments are passed through the behat.yml.
   */
  public function __construct(array $parameters) {
    $this->parameters = $parameters;

    //  Get Object Repository
    $repoPath = $this->parameters['repository'] . '/' . 'ObjectRepository.ini';
    $this->repoElements = parse_ini_file($repoPath);

    //  Generate random strings for each scenario.
    $this->generateRandomStrings();
  }

  /**
   * @BeforeScenario
   *
   * Allow access to the MinkContext.
   */
  public function gatherContexts(BeforeScenarioScope $scope) {
    $environment = $scope->getEnvironment();
    $this->minkContext = $environment->getContext('Drupal\DrupalExtension\Context\MinkContext');
  }

  /**
   * @Given I maximise the browser window
   */
  public function maximiseTheBrowserWindow() {
    $this->getSession()->maximizeWindow();
  }

  /**
   * Generate random numbers/strings to be used throughout the scenarios.
   */
  public function generateRandomStrings() {
    $this->randomItems = new RandomItems();

    // Generate a random number
    $this->randomItems->number = date("U");

    // Generate a random alphanumeric string
    $this->randomItems->alphaNumber = uniqid();

    // Generate a random string
    $this->randomItems->alpha = substr(str_shuffle("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, 8);
  }

  /**
   * @AfterStep
   *
   * Take screenshot when step fails.
   */
  public function takeScreenshotAfterFailedStep(AfterStepScope $scope) {
    if (self::ERROR_CODE === $scope->getTestResult()->getResultCode()) {
      $driver = $this->getSession()->getDriver();

      //  Get the text of the failed step.
      $failed_test_step = $scope->getStep()->getText();

      //  Remove quotes from the test step name.
      $failed_test_step = str_replace('"', '', $failed_test_step);

      //  Set the screenshot location
      $filePath = $this->parameters['screenshots'];

      if ($driver instanceof \Behat\Mink\Driver\BrowserKitDriver) {
        $html_data = $this->getSession()->getDriver()->getContent();
        $fileName = date(self::DATE_FORMAT_CONCISE) . '-' . $failed_test_step . '.html';
        file_put_contents($filePath . '/' . $fileName, $html_data);
        return;
      }

      if ($driver instanceof \Behat\Mink\Driver\Selenium2Driver) {
        $fileName = date(self::DATE_FORMAT_CONCISE) . '-' . $failed_test_step . '.jpg';
        $this->saveScreenshot($fileName, $filePath);
        return;
      }
    }
  }
  /*******************************************************************************
   * End of INITIALISATION functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of WAITING functions.
   *******************************************************************************/

  /**
   * Wait for an element to appear identified by CSS.
   * @Given wait until css element :css is visible
   */
  public function iWaitForElementToBeVisibleByCSS($css) {
    $this->find('css', $css);
  }

  /**
   * Wait for an element to appear identified by an Xpath.
   * @Given wait until xpath element :xpath is visible
   */
  public function iWaitForElementToBeVisibleByXpath($xpath) {
    $this->find('xpath', $xpath);
  }

  /**
   * Finds an element within a given timeout
   * @param string $type
   *  The type of element identifier
   * @param string $locator
   *  The locator of the element.
   * @param int $retries
   * @return bool The boolean returned from the function.
   * The boolean returned from the function.
   * @throws \Exception
   */
  public function find($type, $locator, $retries = self::RETRIES) {
    return $this->spin(function ($context) use ($type, $locator) {
      $page = $this->getSession()->getPage();
      if ($element = $page->find($type, $locator)) {
        if ($element->isVisible()) {
          return $element->isVisible();
        }
      }
      return FALSE;
    }, $retries, $locator);
  }

  /**
   * Return true if an element is located
   * @param callable $lambda
   *  The anonymous function passed from the calling function.
   * @param int $retries
   *  The maximum number of retries.
   * @param string $locator
   *  The locator of the element.
   * @return bool
   *  The boolean returned from the function.
   * @throws \Exception
   *  The exception if the element cannot be found.
   */
  public function spin($lambda, $retries, $locator) {
    for ($i = 0; $i < $retries; $i++) {
      try {
        if ($lambda($this)) {
          return TRUE;
        }
      } catch (Exception $e) {
        // do nothing
      }
      sleep(1);
    }

    throw new CWContextException("Timeout thrown by spinner - element {$locator} is not visible after 30 seconds.");
  }

  /**
   * @Given I wait for :number seconds
   */
  public function iWaitForSeconds($number) {
    $this->getSession()->wait($number * self::WAIT);
  }

  /**
   * @Given I wait for the page to complete loading
   */
  public function iWaitForPageLoadToComplete() {
    $bool_page_load_complete = FALSE;
    $counter = 0;
    while ((!$bool_page_load_complete) && ($counter < self::TIMEOUT)) {
      $page_state = $this->getSession()
        ->evaluateScript('return window.document.readyState');
      if ($page_state == "complete") {
        $bool_page_load_complete = TRUE;
      }
      else {
        //  Sleep for 1 second between loops.
        sleep(self::SECOND_TO_SLEEP);
        $counter += 1;
      }
    }
  }

  /**
   * @Given wait for jquery
   * This function will wait for jquery to complete.
   */
  public function waitForJquery() {
    sleep(self::SECOND_TO_SLEEP);
    $this->getSession()->wait(self::TIMEOUT, '(0 === jQuery.active)');
    sleep(self::SECOND_TO_SLEEP);
  }

  /*******************************************************************************
   * End of WAITING functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of ELEMENT functions.
   *******************************************************************************/

  /**
   * @Given I select the :modal modal
   */
  public function iSelectTheModal($modal) {
    $this->getSession()->switchToIFrame($modal);
  }

  /**
   * @Given I deselect the modal
   */
  public function iDeselectTheModal() {
    $this->getSession()->switchToIFrame();
  }

  /**
   * @Given I save
   */
  public function iSave() {
    $this->getSession()->getPage()->pressButton("edit-submit");
  }

  /**
   * @Given I assign an id to the nameless frame :frame and switch to it
   * @Given I assign an id to the :number nameless frame :frame and switch to it
   */
  public function iAssignIDToANamelessFrame($frame, $number=0) {
    $javascript = <<<JS
        (function(){
          var elem = document.getElementById('$frame');
          var iframes = elem.getElementsByTagName('iframe');
          var f = iframes['$number'];
          f.id = '$frame';
        })()
JS;
    $this->getSession()->executeScript($javascript);

    // Select a frame.
    $this->getSession()->switchToIFrame($frame);
  }

  /**
   * @Given I fill in :frame frame with :text
   * $parentFrame - the frame that was originally in focus.
   * $targetFrameID - the frame to be interacted with.
   * $text - the text to be entered into the iframe.
   */
  public function iFillInFrameWith($targetFrameID, $text, $modalID = NULL) {
    $this->iAssignIDToANamelessFrame($targetFrameID);

    // Enter text into the frame.
    $this->getSession()
      ->executeScript("document.body.innerHTML = '<p>" . $text . "</p>'");

    // Return to parent or modal window.
    if ($modalID != NULL) {
      // Switch to the main parent window, and re-select the modal.
      $this->getSession()->switchToIFrame();
      $this->iSelectTheModal($modalID);
    }
    else {
      // Switch to the main parent window.
      $this->getSession()->switchToIFrame();
    }
  }

  /**
   * @Given I retrieve value from :iframe iframe
   * $targetFrameID - the frame to be interacted with.
   */
  public function iRetrieveValueFromIFrame($targetFrameID) {
    $this->iAssignIDToANamelessFrame($targetFrameID);

    // Get inner html from the iframe.
    return $this->getSession()
      ->evaluateScript("return document.body.innerHTML;");
  }

  /**
   * @Given I click element with :class class
   * This function allows you to click an element identified by it's class.
   */
  public function iClickElementWithClass($class) {
    $element = $this->getSession()
      ->getPage()
      ->find('xpath', '//*[@class="' . $class . '"]');
    if ($element) {
      $element->click();
    }
    else {
      throw new CWContextException("The element " . $class . " does not exist");
    }
  }

    /**
   * @Given I fill in :field field with :value
   */
  public function iFillInFieldWith($field, $value) {
    $value = str_replace('<number>', $this->randomItems->number, $value);
    $value = str_replace('<alpha_number>', $this->randomItems->alphaNumber, $value);
    $value = str_replace('<alpha>', $this->randomItems->alpha, $value);
    $value = str_replace('<datetime>', date(self::DATE_FORMAT_CONCISE), $value);
    $element = $this->getSession()->getPage()->findById($field);
    if ($element) {
      $element->setValue($value);
    }
    else {
      throw new CWContextException("The element " . $field . " does not exist");
    }
  }

  /**
   * @Given I click element with :xpath xpath
   * This function allows you to click an element identified by an xpath.
   */
  public function iClickElementWithXpath($xpath) {
    $element = $this->getSession()->getPage()->find('xpath', $xpath);
    if ($element) {
      $element->click();
    }
    else {
      throw new CWContextException("The element " . $xpath . " does not exist");
    }
  }

  /**
   * @Given I set the value of :field to :value
   * This function allows you to set the value of an element
   */
  public function iSetTheValueOf($field, $value) {
    $element = $this->getSession()->getPage()->findField($field);
    if ($element) {
      $element->setValue($value);
    }
    else {
      throw new CWContextException("The element " . $field . " does not exist");
    }
  }

  /**
   * @Given scroll into view :element
   * This function will scroll to a given element - useful for when the element is not visible.
   */
  public function scrollIntoView($element_id) {
    $function = <<<JS
      (function(){
        var element = document.getElementById("$element_id");
        element.scrollIntoView(true);
      })()
JS;
    try {
      $this->getSession()->executeScript($function);
    } catch (Exception $e) {
      throw new CWContextException("The scroll into view for element " . $element_id . " did not work");
    }
  }

  /**
   * @Given I select a random entry from :dropdown dropdown
   * This function will select a random entry from a dropdown
   */
  public function iSelectARandomEntryFromDropdown($dropdown) {
    // Check the dropdown exists
    $dropdownElement = $this->getSession()->getPage()->findField($dropdown);
    if (NULL === $dropdownElement) {
      throw new CWContextException("The element " . $dropdown . " does not exist");
    }
    else {
      // Get an array of all the entries in the dropdown
      $handler = $this->getSession()->getSelectorsHandler();
      $optionElements = $dropdownElement->findAll('named', array(
        'option',
        $handler->selectorToXpath('css', 'option')
      ));
      // Check how many entries are in the dropdown
      $countOfOptions = count($optionElements);

      // Select a random number between 1 and the number of entries.
      $randomNumber = rand(1, $countOfOptions - 1);

      // Get a value to select (MAKE SURE IT IS NOT ZERO OR "_add_new_").
      $isFound = FALSE;
      while (!$isFound) {
        $value = $optionElements[$randomNumber]->getValue();

        // Eliminate cases we do not want to select
        switch ($value) {
          case '0':
          case '_add_new_':
            $isFound = FALSE;
            // Select another random number between 1 and the number of entries.
            $randomNumber = rand(1, $countOfOptions - 1);
            break;

          default:
            $isFound = TRUE;
            break;
        }
      }

      // Create xpath string.
      $strXpath = "//*[@id='" . $dropdown . "']";

      // Select that numbered entry from the dropdown.
      $this->getSession()->getDriver()->selectOption( $strXpath , $value);
    }
  }


  /**
   * @Given I verify that value :value is not present in dropdown :dropdown
   * This function will check that a value is not present in a dropdown
   */
  public function check($value, $dropdown) {
    // Check the dropdown exists
    $dropdown = $this->getSession()->getPage()->findField($dropdown);
    if (NULL === $dropdown) {
      throw new CWContextException("The element " . $dropdown . " does not exist");
    }
    else {
      // Get an array of all the entries in the dropdown
      $handler = $this->getSession()->getSelectorsHandler();
      $optionElements = $dropdown->findAll('named', array(
        'option',
        $handler->selectorToXpath('css', 'option')
      ));

      //  Loop through the contents and ensure $value is not present
      foreach ($optionElements as $entry) {
        if (strtoupper($entry->getText()) == (strtoupper($value))) {
          throw new CWContextException("The value '{$value}' is present in the dropdown when it should not be.");
        }
      }
    }
   }


  /**
   * @Given I click on the radiobutton with :label label
   */
  public function iClickOnTheRadiobutton($label) {
    $session = $this->getSession();
    $element = $session->getPage()->find(
      'xpath',
      $session->getSelectorsHandler()
        ->selectorToXpath('xpath', "//*[@class='option'][contains(concat(' ', normalize-space(), ' '), ' $label ')]")
    );
    if (NULL === $element) {
      throw new \InvalidArgumentException(sprintf('Cannot find radiobutton: "%s"', $label));
    }
    $element->click();
  }


  /**
   * @Given I verify the following fields are present:
   *
   * This function will verify a field exists on a page.
   * The function will accept the following field identifiers:
   * - id
   * - name
   * - label
   * - class
   * - button name
   * - checkbox
   * - full xpath
   */
  public function iVerifyTheFollowingFieldsArePresent(TableNode $fields) {
    //  Get a DOM of the current page.
    $dom = $this->createDOMOfPage();

    foreach ($fields->getHash() as $key => $value) {
      $identifier = trim($value['IDENTIFIER']);
      $field = trim($value['FIELD']);

      switch (strtoupper($identifier)) {
        case 'ID':
        case 'NAME':
        case 'CLASS':
          $xpath = "//*[@$identifier='$field']";
          break;

        case 'LABEL':
          $xpath = "//" . $identifier . "[text()[contains(.,'$field')]]";
          break;

        case 'LINK':
          $xpath = "//a[text()[contains(.,'$field')]]";
          break;

        case 'BUTTON':
          $xpath = "//input[@type='submit'][@value='$field']";
          break;

        case 'XPATH':
          $xpath = $field;
          break;

        default:
          throw new CWContextException("The identifier $identifier is not valid for this function.");
      }

      //  Get all the nodes matching the xpath and verify the count.
      $nodes = $this->getNodesMatchingXpath($dom, $xpath);
      if ($nodes->length === 0) {
        throw new CWContextException("The field '$field' was not found");
      }
    }
  }

  /**
   * @Given I verify the field :field is not present
   */
  public function iVerifyTheFieldIsNotPresent($field) {
    //  Get a DOM of the current page.
    $dom = $this->createDOMOfPage();

    //  Get all the assets matching the $field.
    $assets = $this->getNodesMatchingXpath($dom, $field);
    if ($assets->length >= 1 ) {
      throw new CWContextException("This '{$field}' field was located when it should not have been.");
    }
  }

  /*******************************************************************************
   * End of ELEMENT functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of NAVIGATION functions.
   *******************************************************************************/

  /**
   * @Given get the HTTP response code :url
   */
  public function getHTTPResponseCode($url) {
    $headers = get_headers($url, 1);
    return substr($headers[0], 9, 3);
  }

  /**
   * @Given I check the HTTP response code is :code for :url
   */
  public function iCheckTheHttpResponseCodeIsFor($code, $url) {
    $path = $this->getMinkParameter('base_url') . $url;
    $response = $this->getHTTPResponseCode($path);
    if ($response != $code) {
      throw new CWContextException('The status code for {$url} was {$response}');
    }
  }

  /**
   * @Given I should get the following HTTP status responses:
   */
  public function iShouldGetTheFollowingHTTPStatusResponses(TableNode $table) {
    foreach ($table->getRows() as $row) {
      $this->getSession()->visit($row[0]);
      $this->assertSession()->statusCodeEquals($row[1]);
    }
  }

  /**
   * @Given get node id from Edit link
   */
  public function getNodeIDFromEDITLink() {
    $node_id_url = $this->getSession()
      ->getPage()
      ->find("xpath", "//a[text()='Edit']")
      ->getAttribute("href");
    $node_id = $this->extractNodeID($node_id_url);
    return $node_id;
  }

  /**
   * @Given get Node ID
   * This will extract the node id from a URL.
   */
  public function extractNodeID($url) {
    preg_match('~node/(.*?)/~', $url, $node_id);
    return $node_id[1];
  }

  /*******************************************************************************
   * End of NAVIGATION functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of REGION functions.
   *******************************************************************************/

  /**
   * @Given I can see :text in the :region region
   */
  public function iCanSeeInTheRegion($text, $region) {
    $region = $this->repoElements[$region];
    $this->minkContext->assertElementContainsText($region, $text);
  }

  /**
   * @Given I cannot see :text in the :region region
   */
  public function iCannotSeeInTheRegion($text, $region) {
    $region = $this->repoElements[$region];
    $this->minkContext->assertElementNotContainsText($region, $text);
  }

  /**
   * @Given I can see the link :link in the :region region
   */
  public function iCanSeeTheLinkInTheRegion($link, $region) {
    $region = $this->repoElements[$region];
    $this->minkContext->assertLinkVisible($link);
    $this->minkContext->assertElementContainsText($region, $link);
  }

  /**
   * @Given I cannot see the link :link in the :region region
   */
  public function iCannotSeeTheLinkInTheRegion($link, $region) {
    $region = $this->repoElements[$region];
    $this->minkContext->assertNotLinkVisible($link);
    $this->minkContext->assertElementNotContainsText($region, $link);
  }

  /*******************************************************************************
   * End of REGION functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of MESSAGE functions.
   *******************************************************************************/

  /**
   * @Given I can see the message containing :message
   */
  public function iCanSeeTheMessageContaining($message) {
    $this->iCanSeeInTheRegion($message, self::MESSAGE_REGION);
  }

  /**
   * @Given I can see the success message containing :message
   */
  public function iCanSeeTheSuccessMessageContaining($message) {
    $this->iCanSeeInTheRegion($message, self::SUCCESS_MESSAGE_REGION);
  }

  /**
   * @Given I can see the error message containing :message
   */
  public function iCanSeeTheErrorMessageContaining($message) {
    $this->iCanSeeInTheRegion($message, self::ERROR_MESSAGE_REGION);
  }

  /**
   * @Given I cannot see the error message containing :message
   */
  public function iCannotSeeTheErrorMessageContaining($message) {
    $this->iCannotSeeInTheRegion($message, self::ERROR_MESSAGE_REGION);
  }

  /**
   * @Given the following error messages are displayed:
   */
  public function theFollowingErrorMessagesAreDisplayed(TableNode $messages) {
    foreach ($messages->getHash() as $key => $value) {
      $message = trim($value['ERROR MESSAGE']);
      $this->iCanSeeInTheRegion($message, self::ERROR_MESSAGE_REGION);
    }
  }

  /**
   * @Given the following login error messages are displayed:
   */
  public function theFollowingLoginErrorMessagesAreDisplayed(TableNode $messages) {
    foreach ($messages->getHash() as $key => $value) {
      $message = trim($value['ERROR MESSAGE']);
      $this->iCanSeeInTheRegion($message, self::LOGIN_ERROR_MESSAGE_REGION);
    }
  }

  /**
   * @Given the following error messages are not displayed:
   */
  public function theFollowingErrorMessagesAreNotDisplayed(TableNode $messages) {
    foreach ($messages->getHash() as $key => $value) {
      $message = trim($value['ERROR MESSAGE']);
      $this->iCannotSeeInTheRegion($message, self::ERROR_MESSAGE_REGION);
    }
  }

  /*******************************************************************************
   * End of MESSAGE functions.
   *******************************************************************************/

  /*******************************************************************************
   * Start of ASSET  functions.
   *******************************************************************************/

  /**
   * @Given I create a DOM object from the HTML of the page
   *
   * Assume result rows always start with the 'em' tag.
   */
  public function createDOMOfPage() {
    $dom = new DOMDocument();
    libxml_use_internal_errors(TRUE);
    $dom->loadHTML($this->getHtml());
    $dom->preserveWhiteSpace = FALSE;
    return $dom;
  }

  /**
   * @Given I get nodes matching an xpath
   */
  public function getNodesMatchingXpath($dom, $xpath) {
    //  Create a DOMXpath object.
    $xpathDOM = new DomXPath($dom);
    $nodes = $xpathDOM->query($xpath);
    return $nodes;
  }

  /**
   * @Given I verify the :asset assets
   */
  public function iVerifyTheAssets($assetType) {
    //  Get a DOM of the current page.
    $dom = $this->createDOMOfPage();

    //  Xpath of the assets.
    switch (strtoupper($assetType)) {
      case "SCRIPT":
        $xpath = "//script/@src";
        break;

      case "LINK":
        $xpath = "//link/@href";
        break;

      case "META":
        $xpath = "//meta/@content";
        break;

      case "IMAGE":
        $xpath = "//img/@src";
        break;

      case "HYPERLINK":
        $xpath = "//a/@href";
        break;

      default:
        throw new CWContextException("This asset '{$assetType}' is not a valid value for this test.");
    }

    //  Get all the assets matching the xpath.
    $assets = $this->getNodesMatchingXpath($dom, $xpath);
    foreach ($assets as $asset) {
      $assetToCheck = $asset->nodeValue;

      //  Check the response for the asset (starting with '//')
      if (preg_match('/^\/\//', $assetToCheck, $match)) {
        $this->getSession()->visit($assetToCheck);
      }
      //  Check the response for the asset (starting with 'http' or '/')
      else {
        if (preg_match('/^http|^\//', $assetToCheck, $match)) {
          $this->visitPath($assetToCheck);
        }
      }

      $statusCode = $this->getSession()->getStatusCode();
      if ($statusCode !== 200) {
        throw new CWContextException("This '{$assetType}' asset did not return a 200 response - {$assetToCheck}.");
      }
    }
  }

  /*******************************************************************************
   * End of ASSET functions.
   *******************************************************************************/

  /**
   * @Given I build repository from :page
   *
   * Visits a page and creates a file in features/bootstrap folder.
   */
  public function getObjects($page) {
    //  Go to page.
    $this->visitPath($page);

    //  Get a DOM of the current page.
    $dom = $this->createDOMOfPage();

    // Create array of xpath => name for repository building.
    $toBuild = [
      ["//input[@type='submit']" , 'BUTTON'],
      ["//input[@type='text']"  , 'TEXTFIELD'],
      ["//input[@type='password']" , 'PASSWORD'],
      ["//input[@type='checkbox']" , 'CHECKBOX'],
      ['//select' , 'DROPDOWN']];

    // Run array through buildObjects() function.
    foreach ($toBuild as $toBuildRecord) {
      $this->buildObjects($dom, $toBuildRecord[0], $toBuildRecord[1]);
    }

    //  Add objects to a file.
    $file = "Objects.txt";

    //  Specify file output path.
    $filePath = $this->parameters['repository'];

    //  Prepare a string of the objects.
    $strObjects = '';
    foreach ($this->pageElements as $object) {
      $strObjects .= "\n";
      foreach ($object as $k => $v) {
        $strObjects .= "$k=$v";
      }
    }
    file_put_contents($filePath . '/' . $file, $strObjects);
  }

  /**
   * When passed a dom, xpath and readable name; it will store any matching attributes into a global array.
   * @param string $dom
   *  DOM of page.
   * @param string $xpathofObject
   *  Xpath to the object.
   * @param string $objectType
   *  Name of the object stored.
   */
  private function buildObjects($dom, $xpathofObject, $objectType) {
    //  Save the objects to an array, and keep count of all elements.
    $buffer = array();

    // Create an array of xpathable objects.
    $arrNodes = $this->getNodesMatchingXpath($dom, $xpathofObject);

    // Name the object type within the array.
    $buffer[] = ['OBJECT TYPE' => $objectType];

    // Perform loop to query and store any matches.
    foreach ($arrNodes as $node) {
      $xpathDOM = new DomXPath($dom);

      // If id of object exists, save it.
      $id = $xpathDOM->query("@id", $node);
      if (!empty($id->item(0)->nodeValue)) {
        $buffer[] = ['id' => $xpathDOM->query("@id", $node)->item(0)->nodeValue];
      }

      // If name of object exists, save it.
      $name = $xpathDOM->query("@name", $node);
      if (!empty($name->item(0)->nodeValue)) {
        $buffer[] = ['name' => $xpathDOM->query("@name", $node)->item(0)->nodeValue];
      }

      // If value of object exists, save it.
      $value = $xpathDOM->query("@value", $node);
      if (!empty($value->item(0)->nodeValue)) {
        $buffer[] = ['value' => $xpathDOM->query("@value", $node)->item(0)->nodeValue];
      }
    }

    // Append buffer array to the global array.
    $this->pageElements = array_merge( $this->pageElements, $buffer);
  }

  /**
   * @Given I get the HTML of the page
   *
   * @return string
   */
  public function getHtml() {
    if (empty($this->html)) {
      $this->html = $this->getSession()->getPage()->getHTML();
    }

    return $this->html;
  }

  /**
   * Asserts that a given content type is editable.
   *  - replaces the default DrupalContext minus the status code check.
   *
   * @Then I am able to edit a/an :type( content)
   */
  public function assertEditNodeOfType($type) {
    $node = (object) array('title' => 'Test Title', 'type' => $type);
    $saved = $this->nodeCreate($node);

    // Set internal browser on the node edit page.
    $this->getSession()->visit($this->locatePath('/node/' . $saved->nid . '/edit'));
  }
}

/**
 * Class RandomItems
 *
 * A class to store random numbers and strings.
 */
class RandomItems {

  /**
   * A random number.
   * @var integer
   */
  public $number;

  /**
   * A random alphanumeric string.
   * @var string
   */
  public $alphaNumber;

  /**
   * A random string.
   * @var string
   */
  public $alpha;

}

/**
 * Class CWContextException
 *
 * A class to handle exceptions.
 */
class CWContextException extends Exception {

}