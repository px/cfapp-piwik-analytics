"use strict"

# document = document || [];
    
_debug = _debug or true

get_tracker = "default tracker"


_delay = 1.0

window.onload = document.getElementById("timeDiv").innerHTML = "Timer update in " + _delay+ " seconds, or async onload."

window._paq = window._paq || []

## window.window.piwikConfig = window.window.piwikConfig or {}
window._paq.push [->
  window._pk_visitor_id = @getVisitorId()
]

myVar = setTimeout ->
     update_status()
   ,1000*_delay 

#window._pk_visitor_id="default id";

# _paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

#window.onload=update_status();


update_status = ->

  try
    document.getElementById("timeDiv").innerHTML = "Timer updated, " + _delay
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("default_piwik_js").innerHTML = "default_piwik_js=" + window.piwikConfig.default_piwik_js
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
    document.getElementById("site_id").innerHTML = "site_id=" + (window.piwikConfig.site_id)
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("trackerURL").innerHTML = "trackerURL=" + (window.piwikConfig.tracker)
  catch e
    console.error "ERR: " + e
    
  #  try {
  #      document.getElementById("getTracker").innerHTML = "getTracker="+(get_tracker);
  #      } catch (e) {
  #      console.error('Testing console '+e);
  #      }
  #      
  try
    document.getElementById("paq_push").innerHTML = "paq_push=" + (window.piwikConfig.paq_push)
  catch e
    console.error "ERR: " + e
  

