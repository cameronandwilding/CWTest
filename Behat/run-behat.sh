#!/usr/bin/env bash

#  Start PhantomJS webdriver
sh ../Servers/start_phantomjs_webdriver.sh

#  Copy project specific feature files into the submodule.case
cp ../../Project.feature features/

#  Run Behat tests
#   - $1 passed from Jenkins job / command line - the tags to be used.
#   - $2 passed from Jenkins job / command line - the profile to be used.
printf "\nStarting the Behat tests...\n"

#  Jenkins / Command line
bin/behat --tags=@$1 -p $2

#  Command line
#bin/behat -p phantomjs --tags=@regression

#  Stop PhantomJS webdriver
sh ../Servers/stop_phantomjs_webdriver.sh