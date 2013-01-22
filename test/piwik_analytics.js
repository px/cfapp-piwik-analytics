/*
 * This is a Sample Piwik AJAX setup for Miniature Hipster Reference
 *  
 *  Rob Friedman <px@ns1.net>
 *  <http://playerx.net>
 *
 * */
//"use strict"

/*
 * A variety of the available options to push into the _paq array for tracking
 * Not a complete list.
 * */

//var d = window.document;

var siteId = 26;
var idGoal = 1;
var customRevenue = 2;

/* instansiate a global array for _paq */
var _paq=_paq||[];

/* configure a base url for requests to the tracker and for the piwik.js library */
var pkBaseURL="https://piwik-ssl.ns1.net/";

/* push some configuration options on to the _paq array for processing by the 'piwik.js' once loaded. */
_paq.push(['setSiteId',siteId]);
_paq.push(['setTrackerUrl',pkBaseURL+'piwik.php']);
_paq.push(['setRequestMethod',"GET"]); // OR "POST"
_paq.push(['setDocumentTitle',document.title]);
_paq.push(['setLinkTrackingTimer',500]);
_paq.push(['setDomains','*.ns1.net','ns1.net','beta.ns1.net']);
_paq.push(['setCookiePath','/user/MyUsername']);
_paq.push(['setCookieDomain','*.ns1.net','ns1.net','beta.ns1.net']);
_paq.push(['setDoNotTrack',true]);
// _paq.push(['redirectFile','http://ns1.net']);
_paq.push(['setCountPreRendered',true]);
_paq.push(['setHeartBeatTimer',30,60]);
_paq.push(['setVisitorCookieTimeout',946080000]);
_paq.push(['setSessionCookieTimeout',900]);
_paq.push(['trackGoal', idGoal, customRevenue]);
_paq.push(['enableLinkTracking',true]);
_paq.push(['trackPageView']);

/*
 * The default javascript code to asynchronously load the piwik.js
 * */

try{
  var g=document.createElement('script'),s=document.getElementsByTagName('script')[0];
  g.type='text/javascript';
  g.defer=true;
  g.async=true;
  g.src=pkBaseURL+'piwik.js';
  s.parentNode.insertBefore(g,s);
}
catch(err){}


