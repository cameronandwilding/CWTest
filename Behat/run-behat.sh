#!/usr/bin/env bash

## Assign script variables
## $1 passed from Jenkins job / command line - the tags to be used.
## $2 passed from Jenkins job / command line - the profile to be used.
TAG=$1
PROFILE=$2
NAME=$3

## Help option
if [ "$1" == "-h" ]; then
  echo "To execute all tests: sh run-behat.sh regression firefox"
  echo "To execute a specific named test: sh run-behat.sh regression firefox \"name_of_test\""
  exit 0
fi

## Shell script must always be passed a tag and profile
if [ -z $PROFILE ] || [ -z $TAG ]
then
   echo "ERROR: Expected Tag followed by Profile"
   exit 1
fi

## Sync files to behat folder for execution
rsync ../../Behat_Test_Files/*.feature features/
rsync ../../Behat_Test_Files/*.php features/bootstrap
rsync ../../Behat_Test_Files/*.ini features/bootstrap
rsync -av --exclude-from=../../Behat_Test_Files/images/.gitkeep ../../Behat_Test_Files/images/ images

## Move previous result files to a History folder
mv ../Results/Behat/*.html ../Results/Behat/History

## Handle behat executing logic
## Extra profiles should be added after the last if
## Add profile to teardown where necessary

#  Selenium Server
if [ $PROFILE = "firefox" ] || [ $PROFILE = "chrome"  ]
then
   sh ../Servers/start_selenium_server.sh;
   if [ ! -z "$NAME" ]
   then
      bin/behat --tags=@$TAG -p $PROFILE --name="$NAME" -f junit -f html -f pretty
   else
      bin/behat --tags=@$TAG -p $PROFILE -f junit -f html -f pretty
   fi
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
if [ $PROFILE = "phantomjs" ]
then
   sh ../Servers/stop_phantomjs_webdriver.sh
fi

#  Stop Selenium server
if [ $PROFILE = "firefox" ] || [ $PROFILE = "chrome"  ]
then
   sh ../Servers/stop_selenium_server.sh
fi