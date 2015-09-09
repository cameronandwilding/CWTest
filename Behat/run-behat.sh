#!/usr/bin/env bash

#  Start PhantomJS webdriver
sh ../Servers/start_phantomjs_webdriver.sh

#  Copy project specific feature files into the submodule.case
#cp ../../Project.feature features/
ln -s ../../Project.feature features/Project.feature

#  Run Behat tests
#   - $1 passed from Jenkins job / command line - the tags to be used.
#   - $2 passed from Jenkins job / command line - the profile to be used.
printf "\nStarting the Behat tests...\n"

#  Jenkins / Command line
bin/behat --tags=@$1 -p $2

#  Command line
#bin/behat -p phantomjs --tags=@regression

#  Remove symlinks
#rm features/Project.feature

#  Stop PhantomJS webdriver
sh ../Servers/stop_phantomjs_webdriver.sh