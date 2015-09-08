<?php
/**
 * @file
 *
 * This is the supporting context file for the PROJECTNAME project.
 */

use Behat\Behat\Hook\Scope\BeforeScenarioScope;
use Behat\Behat\Context\Context;

/**
 * Class ProjectContext
 * Defines application specific functions.
 */
class ProjectContext implements  Context {

  /**
   * @var CWContext
   */
  private $CWContext;

  /**
   * Initializes context.
   */
  public function __construct() {
  }

  /**
   * @BeforeScenario
   *
   * Allow access to the CWContext.
   */
  public function gatherContexts(BeforeScenarioScope $scope) {
    $environment = $scope->getEnvironment();
    $this->CWContext = $environment->getContext('CWContext');
  }
}
