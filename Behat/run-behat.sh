#!/usr/bin/env bash

## Assign script variables
## $1 passed from Jenkins job / command line - the tags to be used.
## $2 passed from Jenkins job / command line - the profile to be used.
TAG=$1
PROFILE=$2

## Sync files to behat folder for execution
rsync ../../Behat_Test_Files/Project.feature features/
rsync -av --exclude-from=../../Behat_Test_Files/images/.gitkeep ../../Behat_Test_Files/images/ images

## Handle behat executing logic
## Extra profiles should be added after the last if

#  Selenium Server
if [ $PROFILE = "firefox" ] || [ $PROFILE = "chrome"  ]
then
   sh ../Servers/start_selenium_server.sh;
   bin/behat --tags=@$TAG -p $PROFILE
fi

#  PhantomJS
if [ $PROFILE = "phantomjs" ]
then
   sh ../Servers/start_phantomjs_webdriver.sh;
   bin/behat --tags=@$TAG -p $PROFILE
fi

## Begin Teardown
#  Remove copied files
rm features/Project.feature
rm -R images/

#  Stop PhantomJS webdriver
sh ../Servers/stop_phantomjs_webdriver.sh

#  Stop Selenium server
sh ../Servers/stop_selenium_server.sh
