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

#   Remove the guzzlehttp/promises and guzzlehttp/psr folders ( Drupal 8 only )
rm -rf Behat/vendor/guzzlehttp/promises
rm -rf Behat/vendor/guzzlehttp/psr7

#  Generate new composer autoload files.
cd Behat
composer dump-autoload
cd ..

#  Create a behat.local.yml file.
cat > Behat/behat.local.yml << EOF
default:
  extensions:
    Behat\MinkExtension:
      base_url: http://showandtell.local
    Drupal\DrupalExtension:
      drupal:
        drupal_root: /Applications/MAMP/htdocs/show-and-tell-d8/webroot
EOF

cat > VisualDiff/behat.local.yml << EOF
default:
  extensions:
    Behat\MinkExtension\Extension:
      base_url: http://showandtell.local
EOF