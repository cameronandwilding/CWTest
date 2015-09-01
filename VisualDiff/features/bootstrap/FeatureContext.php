<?php

use Behat\Gherkin\Node\PyStringNode,
  Behat\Gherkin\Node\TableNode;
use Behat\MinkExtension\Context\Minkcontext,
  Behat\MinkExtension\Context\RawMinkContext;

/**
 * Features context.
 */
class FeatureContext extends MinkContext {
  /**
   * Initializes context.
   * Every scenario gets its own context object.
   *
   * @param array $parameters context parameters (set them up through behat.yml)
   */
  public function __construct(array $parameters) {
  }

  /**
   * @Given /^I set the browser window size to "([^"]*)" x "([^"]*)"$/
   */
  public function iSetTheBrowserWindowSizeToX($width, $height) {
    $this->getSession()->resizeWindow((int) $width, (int) $height, 'current');
  }
}
