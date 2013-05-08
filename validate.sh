#!/usr/bin/env bash
set -x

# clunky but works :)

_FILE=public/javascripts/piwik_analytics.js

find ./ -type f -name \*.js -exec jsl -process {} \;

# minify and concatenate with the header
cat public/javascripts/header.js >public/javascripts/piwik_analytics.min.js
jsmin <public/javascripts/piwik_analytics.js >>public/javascripts/piwik_analytics.min.js

echo copy over in place cloudflare.json
#find ./ -type f -name \*.json -exec jsonlint-i {} \;

jsonlint -process cloudflare.json  >cloudflare.json2 ;mv cloudflare.json2 cloudflare.json
