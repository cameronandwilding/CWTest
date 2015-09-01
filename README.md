IWM - AUTOMATION TESTS
======================

Tool setup
==========

Behat/Visual Diff:
1. Install Behat, Visual Diff and Selenium Server:
    - sh composer_install.sh
    
2. Modify your local Behat configuration file. Inside 'Behat/behat.local.yml', update:
      - the base_url to your local site url
      - the 'drupal_root' value to the path to your local drupal installation.
         
3. Modify your local VisualDiff configuration file. Inside 'VisualDiff/behat.local.yml', update:
      - the base_url to your local site url

NodeJS and PhantomJS:
1. Install NodeJS:
 - sudo npm install -g nodejs
 
2. Install PhantomJS:
 - sudo npm install -g phantomjs


Install chromedriver (optional step):
1. Download chromedriver from http://chromedriver.storage.googleapis.com/index.html?path=2.17/
2. Save it to /usr/bin

Install safaridriver (optional step):
1. Download SafariDriver.safariextz from http://selenium-release.storage.googleapis.com/index.html?path=2.45/


Test Execution
==============

Behat:
1. Open a terminal window.
2. Navigate to <LOCAL DRUPAL INSTALL>/cw_test/Behat
3. To excute the tests, select one of the following options based on the format 'sh run-beht.sh <tag> <profile>':
 - sh run-behat.sh smoke chrome
 - sh run-behat.sh regression chrome
 - sh run-behat.sh smoke firefox
 - sh run-behat.sh regression firefox
 - sh run-behat.sh smoke phantomjs
 - sh run-behat.sh regression phantomjs

Visual Diff:
1. Open a terminal window.
2. Navigate to <LOCAL DRUPAL INSTALL>/cw_test/VisualDiff
3. Type 'sh run-visualdiff.sh'


Test Results
============

The results of all tests will be stored in <LOCAL DRUPAL INSTALL>/cw_test/Results.