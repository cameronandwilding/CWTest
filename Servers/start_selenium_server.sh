#!/bin/bash

function isSeleniumServerRunning {
  if ! lsof -i:4444
  then
    echo Port 4444 is free
    printf "\nStarting selenium server...\n"
    runSeleniumServer
    sleep 4;
  else
    echo Port 4444 is in use
    printf "\nSelenium server already running.\n"
  fi
}

function runSeleniumServer {
  java -jar ../Servers/selenium.jar -port 4444 -trustAllSSLCertificates &
}

isSeleniumServerRunning

