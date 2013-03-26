#!/bin/sh


URL=https://github.com/piwik/piwik/raw/master/piwik.js
wget ${URL} --output-document=public/javascripts/piwik.js
