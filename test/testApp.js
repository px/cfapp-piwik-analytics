"use strict";

// document = document || [];


var _debug = _debug || true;


var _paq = _paq || []; 
var visitor_id="default id";
var get_tracker="default tracker";

_paq.push([ function() { visitor_id = this.getVisitorId(); }]);
// _paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

function update_status(document, piwikConfig) {
  document.getElementById("visitorId").innerHTML = "getVisitorId="+ visitor_id ;
  document.getElementById("timeDiv").innerHTML = "Timer update";

  try {

    document.getElementById("piwik_js_default").innerHTML = "piwik_js_default="+piwikConfig.piwik_js_default;
    document.getElementById("js_url").innerHTML = "js_url="+piwikConfig.js_url;
    document.getElementById("use_cdnjs").innerHTML = "use_cdnjs="+ piwikConfig.use_cdnjs ;


    document.getElementById("site_id.a").innerHTML = "site_id.a="+piwikConfig.site_id.a;
    document.getElementById("site_id.b").innerHTML = "site_id.b="+piwikConfig.site_id.b;

    document.getElementById("trackerURL.a").innerHTML = "trackerURL.a="+piwikConfig.tracker.a;
    document.getElementById("trackerURL.b").innerHTML = "trackerURL.b="+piwikConfig.tracker.b;

    document.getElementById("getTracker").innerHTML = "getTracker="+get_tracker;

    document.getElementById("paq_push.a").innerHTML = "paq_push.a="+piwikConfig.paq_push.a;
    document.getElementById("paq_push.b").innerHTML = "paq_push.b="+piwikConfig.paq_push.b;
  } catch (e) {

    /* silently ignore the error */
  }

}

var timerSec=0.5;

var myVar = setInterval( function() { myTimer(); } , timerSec*1000 );


function myTimer()
{
  update_status(document, piwikConfig);
}

