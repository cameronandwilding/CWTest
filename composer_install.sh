#!/bin/sh

#  Get Selenium Server.
wget http://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar -O Servers/selenium.jar

#  Install the following via their composer.json:
#  - Behat
#  - VisualDiff

export COMPOSER_HOME="./"
for dir in \
  Behat \
  VisualDiff
do
  composer install -d $dir
  rm -rf $dir/.htaccess
done

