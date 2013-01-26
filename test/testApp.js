"use strict";

// document = document || [];


var _debug = _debug || true;
var timerSec=2.5;


var _paq = _paq || []; 
var piwikConfig = piwikConfig || {};


// _paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

var myVar = setInterval( function() { myTimer(); } , timerSec*1000 );

function myTimer()
{
  update_status(document, piwikConfig);
}

function update_status(document, piwikConfig) {

  var visitor_id="default id";
  var get_tracker="default tracker";

  _paq.push([ function() { visitor_id = this.getVisitorId(); }]);

  document.getElementById("visitorId").innerHTML = "getVisitorId="+ visitor_id ;
  document.getElementById("timeDiv").innerHTML = "Timer update seconds=" + timerSec;

  try {
    document.getElementById("piwik_js_default").innerHTML = "piwik_js_default="+piwikConfig.piwik_js_default;
  } catch (e) {
    console.error('Testing console '+e);
  }
  try {
    document.getElementById("js_url").innerHTML = "js_url="+piwikConfig.js_url;
  } catch (e) {
    console.error('Testing console '+e);
  }
  try {
    document.getElementById("use_cdnjs").innerHTML = "use_cdnjs="+ piwikConfig.use_cdnjs ;
  } catch (e) {
    console.error('Testing console '+e);
  }

  try {
    document.getElementById("site_id.a").innerHTML = "site_id.a="+(piwikConfig.site_id.a);
  } catch (e) {
    console.error('Testing console '+e);
  }
  try {
    document.getElementById("site_id.b").innerHTML = "site_id.b="+(piwikConfig.site_id.b);
  } catch (e) {
    console.error('Testing console '+e);
  }

  try {
    document.getElementById("trackerURL.a").innerHTML = "trackerURL.a="+(piwikConfig.tracker.a);
  } catch (e) {
    console.error('Testing console '+e);
  }
  try {
    document.getElementById("trackerURL.b").innerHTML = "trackerURL.b="+(piwikConfig.tracker.b);
  } catch (e) {
    console.error('Testing console '+e);
  }

  /*  try {
      document.getElementById("getTracker").innerHTML = "getTracker="+(get_tracker);
      } catch (e) {
      console.error('Testing console '+e);
      }
      */
  try {
    document.getElementById("paq_push.a").innerHTML = "paq_push.a="+(piwikConfig.paq_push.a);
  } catch (e) {
    console.error('Testing console '+e);
  }
  try {
    document.getElementById("paq_push.b").innerHTML = "paq_push.b="+(piwikConfig.paq_push.b);
  } catch (e) {
    console.error('Testing console '+e);
  }

}

