#!/usr/bin/env bash

#  Start PhantomJS webdriver
sh ../Servers/start_phantomjs_webdriver.sh

#  Run Behat tests
#   - $1 passed from Jenkins job / command line - the tags to be used.
#   - $2 passed from Jenkins job / command line - the profile to be used.
printf "\nStarting the Behat tests...\n"
bin/behat --tags=@$1 -p $2


#  Stop PhantomJS webdriver
sh ../Servers/stop_phantomjs_webdriver.sh