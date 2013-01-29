"use strict"

# document = document || [];
    
_debug = _debug or true

get_tracker = "default tracker"


_delay = 1.0

window.onload = document.getElementById("timeDiv").innerHTML = "Timer update in " + _delay+ " seconds, or async onload."

window._paq = window._paq || []

## window.window.piwikConfig = window.window.piwikConfig or {}
window._paq.push [->
  window._visitor_id = @getVisitorId()
]

myVar = setTimeout ->
     update_status()
   ,1000*_delay 

#window._visitor_id="default id";

# _paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

#window.onload=update_status();


update_status = ->
  #  window._paq.push [->
  #  window._visitor_id = @getVisitorId()
  #]
  
  document.getElementById("visitorId").innerHTML = "Test App getVisitorId=" + window._visitor_id


  try
    document.getElementById("timeDiv").innerHTML = "Timer updated, " + _delay
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("piwik_js_default").innerHTML = "piwik_js_default=" + window.piwikConfig.piwik_js_default
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("js_url").innerHTML = "js_url=" + window.piwikConfig.js_url
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("use_cdnjs").innerHTML = "use_cdnjs=" + window.piwikConfig.use_cdnjs
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("site_id.a").innerHTML = "site_id.a=" + (window.piwikConfig.site_id.a)
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("site_id.b").innerHTML = "site_id.b=" + (window.piwikConfig.site_id.b)
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("trackerURL.a").innerHTML = "trackerURL.a=" + (window.piwikConfig.tracker.a)
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("trackerURL.b").innerHTML = "trackerURL.b=" + (window.piwikConfig.tracker.b)
  catch e
    console.error "ERR: " + e
  
  #  try {
  #      document.getElementById("getTracker").innerHTML = "getTracker="+(get_tracker);
  #      } catch (e) {
  #      console.error('Testing console '+e);
  #      }
  #      
  try
    document.getElementById("paq_push.a").innerHTML = "paq_push.a=" + (window.piwikConfig.paq_push.a)
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("paq_push.b").innerHTML = "paq_push.b=" + (window.piwikConfig.paq_push.b)
  catch e
    console.error "ERR: " + e


