## Codename: Miniature Hipster 
### A Piwik App for Cloudflare

This Piwik Analytics Cloudflare Application will help you add the Piwik tracking code on your website pages. To use this app, you need to have Piwik [installed](http://piwik.org/docs/installation/) already, or use a [Piwik Hosting](http://piwik.org/hosting/) package. Setup [your configured domains](https://www.cloudflare.com/cloudflare-apps).




#### App Features


##### Link Tracking
* Easily enable open source analytics tracking for outlinks from your web properties.




##### Privacy Features
* By default obey a visitor's "[Do-Not-Track](https://www.eff.org/issues/do-not-track)" option with [supported browsers](https://ie.microsoft.com/testdrive/browser/donottrack/default.html).
* Loads piwik.js from your own Piwik installation.


## Installation & Configuration


### Simple Configuration
1. Turn it on. Configure where your **Piwik Installation URL** is. By default it will attempt to use **'/piwik'** as a relative URL. This is used to load the *piwik.js* library, and also for the tracker destination.
2. Configure a **Website ID** for the domain. If not specified, it will default to use **'1'**.
3. Click **UPDATE**, if configured properly all pages should have Piwik Analytics tracking enabled on them.



#### More Details
* Piwik Installation URL
  * *'https://piwik.example.com'*. Do not add a trailing **'/'** character. Ideally should be utilizing [SSL](https://support.cloudflare.com/forums/21317627-SSL-at-CloudFlare) transport for security purposes. Using a schemeless URL **'//host.tld'** is also valid for use of other protocols, such as [SPDY](https://www.cloudflare.com/spdy). But only if your tracker installation supports it. Leaving this empty will use the default relative URL **'/piwik'**
* Piwik Site Id
  * Website Id to be tracked. If not specified, it will default to use **'1'**.


#### Advanced Configuration
Looking for more? Piwik is an incredible application. It contains a very large feature set of well documented API calls. Through use of these [Javascript tracking](http://piwik.org/docs/javascript-tracking/) features, and the **Advanced \_paq** field, you will be able to utilize the complete set of Piwik API calls available for your installation.

1. Enable the **Advanced Features Menu** option.
2. Try out some **Advanced \_paq** features. *Examples:*
  * Return 0 `[ function() { return 0;} ]`
  * Hello World displayed in console log `[ function() { return window.console.log( "Hello World"); } ]`
  * Get VisitorId and display in console log `[ function() { return window.console.log( "getVisitorId=" + this.getVisitorId() ); } ]`
  * Set the Document Title using more advanced methods `["setDocumentTitle",document.domain + ' / ' + document.title]`
  * Implement a HeartBeatTimer `['setHeartBeatTimer',30,60]`
3. Enable __Logging__ if you experience issues with the Javascript tracking codes.



## Screenshots
* Main options screen
![Screenshot of Piwik CloudFlare App](/images/apps/piwik_analytics/piwik_cfapp_screenshot_1.png "Main options")

* Advanced Menu Features
![Advanced Menu Features](/images/apps/piwik_analytics/piwik_cfapp_screenshot_2.png "Utilize advanced options powered by Piwik and Javascript")


## Open Source & Contribute!
This Piwik Analytics CloudFlare application is an [open source project](https://github.com/px/cfapp-piwik-analytics/?utm_src=cfapp_pa#readme) hosted on [Github](https://github.com/).

It is primarily developed by [Rob Friedman](http://playerx.net/?utm_src=cfapp_pa). Follow <a href="http://twitter.com/px">px</a> on Twitter.

For application comments, or support, please [contact Rob](http://playerx.net/contact/?utm_src=cfapp_pa). Please include your details, a relevant screenshot, and pasted configuration information. Either way, he would love to hear about you. [Say "Hello!"](http://playerx.net/contact/?utm_src=cfapp_pa)

If you are feeling comfortable, please feel free to [contribute](https://github.com/px/cfapp-piwik-analytics/?utm_src=cfapp_pa#contributing) in anyway you can; <a href="https://github.com/px/cfapp-piwik-analytics/issues">file bugs</a>, write documentation, <a href="https://github.com/px/cfapp-piwik-analytics/fork">fork</a>, and <a href="https://github.com/px/cfapp-piwik-analytics/pulls">submit pull requests</a> for consideration. Have an itch? Scratch it!



### About Piwik
Piwik is the leading open source web analytics software, used by more than 460,000 websites. It gives interesting reports on your website visitors, your popular pages, the search engines keywords they used, the language they speak… and so much more. Piwik aims to be an open source alternative to Google Analytics.
More information can be found on the [Piwik Analytics Media page](http://piwik.org/media/).

* [Online Videos about Piwik](https://piwik.org/blog/category/videos/)
* [Piwik Javascript Tracking](http://piwik.org/docs/javascript-tracking/)

* [Screenshot of Piwik Demo](/images/apps/piwik_analytics/piwik_analytics_demo_screenshot_1.png)
![Screenshot of Piwik](/images/apps/piwik_analytics/piwik_analytics_demo_screenshot_1.png "Piwik Demo Screenshot")


