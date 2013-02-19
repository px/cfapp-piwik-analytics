# Codename: Miniature Hipster 
## A Piwik App for Cloudflare

This open source CloudFlare app will load 'piwik.js' into all of your webpages with minimal effort, it will then provide your Piwik tracker with analytics about visitors to [your configured domains](https://www.cloudflare.com/my-websites).

### App Features

#### Speed

  * Use [cdnjs](https://cdnjs.com/) to serve up 'piwik.js' quickly to your visitors(~40-60ms), or your use your own URL.


#### Link Tracking

  * Easily enable open source analytics tracking for outlinks from your web properties.


#### Privacy

  * By default obey a visitor's "[Do-Not-Track](https://www.eff.org/issues/do-not-track)" option with [supported browsers](https://ie.microsoft.com/testdrive/browser/donottrack/default.html).
  * Enable serving your own 'piwik.js' for more control over traffic handling, or sensitive logging needs.


#### Simple

1. Turn it ON.
2. Configure a 'Site ID' for the domain. Or it will use SiteId '1'
3. Configure where 'piwik.js' is loaded. By default it will attempt to use cdnjs, otherwise '/piwik/piwik.js' will be tried.
4. Input a tracker URL. By default it will use '/piwik/piwik.php' as the tracker url. 
5. Click **UPDATE**, if configured properly all pages should have Piwik Analytics tracking enabled on them.


##### About Piwik
Piwik is used to provide analytics about your visitors. More information can be found on the [Piwik homepage](http://piwik.org/).

  * [Online Videos about Piwik](https://piwik.org/blog/category/videos/)
  * [Piwik Javascript Tracking](http://piwik.org/docs/javascript-tracking/)
  

  * TODO
![Screenshot of Piwik](/images/apps/piwik_analytics/piwik_screenshot_1.png "Screenshot")
![Screenshot of Piwik CloudFlare App](/images/apps/piwik_analytics/piwik_screenshot_2.png "Screenshot")

For application comments or support please contact me by <a href="mailto:px+cfapp-piwik-analytics@ns1.net">email</a> or <a href="http://twitter.com/px">Twitter</a>.


#### Open Source
This CloudFlare app is an [open source project](https://github.com/px/cfapp-piwik-analytics/#readme) hosted on [Github](https://github.com/). If you are feeling comfortable, please feel free to [contribute](https://github.com/px/cfapp-piwik-analytics/#contribute), fork and submit pull requests for consideration.



