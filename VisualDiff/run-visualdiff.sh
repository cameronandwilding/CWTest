#!/usr/bin/env bash
date="$(date +%d-%m-%Y:%H:%M)"

#  Start Selenium Server
sh ../Servers/start_selenium_server.sh

#  Run VisualDiff tests
printf "\nStarting the VisualDiff tests...\n"
vendor/bin/behat -f html --out ../Results/VisualDiff/report.html

#  Stop Selenium Server
sh ../Servers/stop_selenium_server.sh