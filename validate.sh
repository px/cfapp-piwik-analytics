#!/usr/bin/env bash
set -x

_FILE=public/javascripts/piwik_analytics.js
jsl -stdin <$_FILE


echo copy over in place cloudflare.json
jsonlint  < cloudflare.json >cloudflare.json2 ; mv cloudflare.json2 cloudflare.json
