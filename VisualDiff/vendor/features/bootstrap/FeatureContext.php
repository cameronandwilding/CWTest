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
  public function iSetTheBrowserWindowSizeToX($width, $height)
  {
    $this->getSession()->resizeWindow((int) $width, (int) $height, 'current');
  }

  /**
   * @Given /^I move the browser window to "(\d+)","(\d+)"$/
   */
  public function iMoveTheBrowserWindowTo($posX, $posY)
  {
      $javascript = <<<JS
      (function(){
        window.scrollTo($posX,$posY)
      })()
JS;
      $this->getSession()->executeScript($javascript);
  }

  /**
   * @Given /^I focus on element "([^"]*)"$/
   */
  public function iFocusOnElement($id)
  {
      $javascript = <<<JS
      (function(){
        var element = document.getElementById('$id');

        //element.scrollIntoView();
        //element.scrollIntoView(false);
        //element.scrollIntoView({block: "end"});
        element.scrollIntoView({block: "end", behavior: "instant"});
      })()
JS;
      $this->getSession()->executeScript($javascript);
  }