#!/usr/bin/env bash

coffee --watch --lint --bare --join piwik_analytics.js --output public/javascripts/ src/coffeescripts/piwik_analytics-hot.coffee

coffee --watch --compile --bare test/testApp.coffee


