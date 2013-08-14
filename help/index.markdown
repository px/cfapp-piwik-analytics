---
title: help
layout: default

---
## Miniature Hipster 
### A Piwik App for Cloudflare

This free Piwik Analytics Cloudflare Application will help you add the Piwik tracking code on your website pages. To use this app, you need to have Piwik [installed](http://piwik.org/docs/installation/) already, or use a [Piwik Hosting](http://piwik.org/hosting/) package.


#### About Piwik
Piwik is the leading open source web analytics software, used by more than 460,000 websites. It gives interesting reports on your website visitors, your popular pages, the search engines keywords they used, the language they speak... and so much more. Piwik aims to be an open source alternative to Google Analytics.
More information can be found on the [Piwik Analytics Media page](http://piwik.org/media/).

* Online [Videos about Piwik](https://piwik.org/blog/category/videos/)
* Piwik [Javascript Tracking](http://piwik.org/docs/javascript-tracking/) Documentation

* [Piwik Demo](/images/apps/piwik_analytics/piwik_analytics_demo_screenshot_1.png) Screenshot
![Screenshot of Piwik](/images/apps/piwik_analytics/piwik_analytics_demo_screenshot_1.png "Piwik Demo Screenshot")




<a name="features"></a>
### App Features

#### Link Tracking
* Easily enable open source analytics tracking for outlinks from your web properties.


<a name="privacy"></a>
#### Privacy Features
* By default obey a visitor's "[Do-Not-Track](https://www.eff.org/issues/do-not-track)" option with [supported browsers](https://ie.microsoft.com/testdrive/browser/donottrack/default.html).
* Loads piwik.js from your own Piwik installation.



<a name="installation"></a>
## Installation & Configuration
Setup [your configured domains](https://www.cloudflare.com/cloudflare-apps).

<a name="configuration"></a>
### <a name="configuration">Simple Configuration</a>
1. Turn it on. Configure where your **Piwik Installation URL** is. 
2. Configure a **Website ID** for the domain.
3. Click **UPDATE**, if configured properly all pages should have Piwik Analytics tracking enabled on them.



### Details
* Piwik Installation URL
  * This is used to load the *piwik.js* library, and also for the tracker destination. Example: `https://piwik.example.com` Do not add a trailing **'/'** character. Ideally it should be utilizing [SSL](https://support.cloudflare.com/forums/21317627-SSL-at-CloudFlare) transport for security purposes. Providing a schemeless URL `//host.tld` is also valid for use of other protocols, such as [SPDY](https://www.cloudflare.com/spdy). But only if your tracker installation supports it. Leaving this empty will use the default relative URL `/piwik`
* Piwik Site Id
  * Website Id to be tracked. If not specified, it will default to use `1`.
* Outlinks
  * A quoted and comma separated list of configured alias URLs, where clicks on those links will not be counted as 'Outlink'. Use of the asterisk ('\*') wildcard token is optional. Example: `"*.other.example.com",".subdomain.example.com"`

<a name="advanced"></a>
### <a name="advanced">Advanced Configuration</a>
Looking for something beyond the norm? Piwik is an incredible application. It contains a very large feature set of well documented API calls. Through use of these [Javascript tracking](http://piwik.org/docs/javascript-tracking/) features, and the **Advanced \_paq** field, you will be able to utilize the complete set of Piwik API calls available for your installation.

1. Enable the **Advanced Features Menu** option.
2. Try out some **Advanced \_paq** features. *Examples:*
  * Return 0 `[ function() { return 0;} ]`
  * Hello World displayed in console log `[ function() { return window.console.log( "Hello World"); } ]`
  * Get VisitorId and display in console log `[ function() { return window.console.log( "getVisitorId=" + this.getVisitorId() ); } ]`
  * Set the Document Title using more advanced methods `["setDocumentTitle",document.domain + ' / ' + document.title]`
  * Implement a HeartBeatTimer `['setHeartBeatTimer',30,60]`
3. Enable __Logging__ if you experience issues with the Javascript tracking codes.

Proud of a practical advanced usage? Consider sharing your results!


<a name="open-source"></a>
## <a name="open-source">Open Source & Contribute!</a>
This work is an [open source project](https://github.com/px/cfapp-piwik-analytics/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=open+source+project#readme) hosted on [Github](https://github.com/). It is available under a <a href='https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt'>BSD 2-Clause</a> License.

If you are feeling comfortable, please feel free to [contribute](https://github.com/px/cfapp-piwik-analytics/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=contribute#contributing) in anyway you can; <a href="https://github.com/px/cfapp-piwik-analytics/issues">file bugs</a>, write documentation, clone, <a href="https://github.com/px/cfapp-piwik-analytics/fork">fork</a>, and <a href="https://github.com/px/cfapp-piwik-analytics/pulls">submit pull requests</a> for consideration. Have an itch? Scratch it!

<a name="tip-jar"></a>
### <a name="tip-jar">Tip Jar</a>
Was this free application useful? Please consider supporting this work by [registering new domains](http://ns1.net/en/domains/new/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=tip-jar), or [transferring current names](http://ns1.net/en/domains/transfer/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=tip-jar) through [NS1.net](http://ns1.net/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=tip-jar).

<a name="author"></a>
### <a name="author">About the Author</a>
[Rob Friedman](http://playerx.net/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=me) got the itch. He is also the Owner/Operator of Suspicious Networks NS1.net.

For comments, or support, [contact Rob](http://playerx.net/contact/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=contact). Please be sure to include some details, a relevant screenshot, and pasted configuration information. Either way, he would love to hear about you. [Say "Hello!"](http://playerx.net/contact/?utm_campaign=cloudflare&utm_src=cfapp_pa&utm_medium=web&utm_content=hello)

<a href="https://twitter.com/intent/tweet?user_id=3288&hashtags=piwik&text=Howdy&related=px%3ARob,piwik%3AFree%20Web%20Analytics%20Software&">Tweet @px "Howdy"</a> and follow <a href="https://twitter.com/intent/user?user_id=3288">@px</a> on Twitter.
<a href="https://twitter.com/intent/tweet?hashtags=opensource&text=Miniature%20Hipster,%20a%20simple%20%40Piwik%20web%20%23analytics%20companion%20for%20%40CloudFlare%20Apps&via=px&related=px,piwik,cloudflare&url=https://www.cloudflare.com/apps/piwik_analytics">Tweet your followers about this app</a>.


