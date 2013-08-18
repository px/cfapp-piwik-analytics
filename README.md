# Miniature Hipster:
## A Piwik App for CloudFlare -- cfapp_piwik_analytics
------------------------------------------------------
[Piwik Analytics](https://www.cloudflare.com/apps/piwik_analytics) CloudFlare App.

  * It is written primarily in [CoffeeScript](http://coffeescript.org/), and compiled into Javascript.

### Initially this app aims to
  * Be asynchronous in loading
  * Support a single Piwik Site ID
  * Support a single Piwik tracker/receiver
  * Work with your own Piwik Analytics installation, or maybe a hosted solution,
  * Improve upon the available Analytics &amp; Tracking options available to CloudFlare users.

### TODO Future
* Utililse "use strict;" when possible for development
* Utilise [cdnjs](http://cdnjs.com/#piwik) for serving piwik.js quickly if enabled, or the parameters are left unsupplied by the user.

* Support:
  * [cookie configuration for domains and sub-domains](http://piwik.org/docs/javascript-tracking/#toc-cookie-configuration-for-domains-and-subdomains)
  * goals, tracking, 5 per site id, maybe more.
  * eventually support [all methods available in the Tracking API](http://piwik.org/docs/javascript-tracking/#toc-list-of-all-methods-available-in-the-tracking-api)
* Describe the [test app](./test) better, and it's individual files.

### IMPOSSIBLE! 
  * provide &lt;noscript&gt; tag for recording visitors without Javascript using a 1x1 gif pixel; CloudFlare no longer supports applications which are not loaded as Javascript modules.


<a name="author"></a>
### About the Author
[Rob Friedman](http://playerx.net/?utm_campaign=github&utm_src=cfapp_pa&utm_content=me) is the primary developer of this application. He is also the Owner/Operator of NS1.net.

For comments, or support, [contact Rob](http://playerx.net/contact/?utm_campaign=github&utm_src=cfapp_pa&utm_content=contact). Please be sure to include your details, a relevant screenshot, and pasted configuration information. Either way, he would love to hear about you. [Say "Hello!"](http://playerx.net/contact/?utm_campaign=github&utm_src=cfapp_pa&utm_content=hello)

Follow <a href="http://twitter.com/px">px</a> on Twitter.




Piwik Documentation
-------------------

 * [Online Videos about Piwik](https://piwik.org/blog/category/videos/)
 * [Piwik Javascript Tracking](http://piwik.org/docs/javascript-tracking/)

About CloudFlare Apps
---------------------
CloudFlare's Apps platform enables developers to create and publish web applications for use by website owners on CloudFlare's network. See the [full list](https://www.cloudflare.com/apps).

* Developer documentation [cloudflare.json manifest](http://appdev.cloudflare.com/next/cloudflare-json.html)

#### My tracking pixels

Thanks for visiting!

![Tracking Pixel](https://piwik-ssl.ns1.net/piwik.php?idSite=26&rec=1)
![Tracking Pixel](https://piwik-ssl.ns1.net/piwik.php?idSite=27&rec=1)
