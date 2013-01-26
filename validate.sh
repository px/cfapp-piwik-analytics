#!/usr/bin/env bash
set -x

jsl -stdin <public/javascripts/piwik_analytics.js


echo copy over in place cloudflare.json
jsonlint  < cloudflare.json >cloudflare.json2 ; mv cloudflare.json2 cloudflare.json
