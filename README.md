# Miniature Hipster:
## A Piwik App for CloudFlare -- cfapp_piwik_analytics

  * [Piwik Analytics](https://www.cloudflare.com/apps/piwik_analytics) CloudFlare App.

Miniature Hipster is the 'random' name provided by Github. I enjoy it, although may change it. But it's kind of interesting.
  * Repository URL  [Piwik Analytics App for Cloudflare](https://github.com/px/cfapp-piwik-analytics.git/)

This CloudFlare App aims to improve upon the available Analytics &amp; Tracking options available to users.

### Initially this App aims to
  * utililse " use stict;" when possible
  * Be asynchronous in loading
  * work with your own Piwik Analytics installation, or maybe a hosted solution
  * Support a single Piwik Site ID
  * Support a single Piwik tracker/receiver
  * provide &lt;noscript&gt; tag for recording visitors without Javascript using a 1x1 gif pixel
  * utilize [cdnjs](http://cdnjs.com) for serving piwik.js quickly if emabled, or the parameters left unsupplied by the user.


### TODO
* Support:
  * multiple versions of piwik, currently only 1.10.1 is loaded into cdnjs. * cdnjs/cdnjs#794: cdnjs/cdnjs/god#794
    * Perhaps the piwik.js is backwards compatible with the tracker, and somehow we can instate a 'trunk' copy. -- FIXME
  * goals, tracking, 5 per site id, maybe more.
  * automatically validate and check .js files
  * automatically validate and check cloudflare.json &amp; other json files with jsonlint

### Piwik Documentation
* [Javascript Tracking](http://piwik.org/docs/javascript-tracking/)

CloudFlare's Apps platform enables developers to create and publish web applications for use by website owners on CloudFlare's network. See the [full list](https://www.cloudflare.com/apps).



### Other stuff

* [jsonlint](https://github.com/zaach/jsonlint)
    npm install jsonlint -g


#### Tracking pixel
![Tracking Pixel](https://piwik-ssl.ns1.net/piwik.php?idSite=26&rec=1)
![Tracking Pixel](https://piwik-ssl.ns1.net/piwik.php?idSite=27&rec=1)
