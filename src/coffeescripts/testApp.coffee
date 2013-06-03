# have to keep "use strict"; disabled for overloading functions
#"use strict"
#

# document = document || [];
window._paq = window._paq || []
#_paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

_debug = _debug or true
_delay = 0.1

#window.piwikConfig = window.CloudFlare[{apps.piwik_analytics}] or window.piwikConfig or 

#window.__piwikConfig = window.__CF.AJS.piwik_analytics or window.__piwikConfig or {}


links = """
<!-- convert to some other file of links to utilize between the other test files. -->
  <ul>
    <li><a href="index.html">index.html</a> -- use the static <a href="../public/javascripts/piwik_analytics/config.js">config.js</a> <a href="../public/javascripts/piwik_analytics.js">CF App</a></li>
    <li><a href="index_min.html">index_min.html</a> -- use the static and <a href="../public/javascripts/piwik_analytics.min.js">minified CF App</a></li>
    <li><a href="cf-config.html">cf-config.html</a> -- use static config, display options from CloudFlare.</li>
    <li><a href="iframeTest.html">iframe buster test</a> -- break out of an iframe. </li>
    <li><a href="example_piwik.html">static example</a> -- shows possible features <a href="piwik_analytics.js">source.js</a>
<li><a href='#/no-tracking' target="_self" class='no-tracking'>Class 'no-tracking' No Tracking Test</a></li>
<li><a href='https://github.com/px/cfapp-piwik-analytics/archive/master.zip' class='piwik_ignore'>File I don't want to track as a download</a> Latest master.zip </li>
<li><a href='#/piwik_download' class='piwik_download'>Link I want to track as a download</a></li>
<li><a href='#/piwik_link' target="_self" class='piwik_link'>Link I want to track as an outlink</a></li>
<li><a href='example_piwik_ajax.html#/' target="_self" class='no-tracking'>Class 'no-tracking' example_piwik_ajax.html</a></li>
<li><a href='#/' target="_self" class='no-tracking'>Class 'no-tracking' No Tracking Test</a></li>
<li><a href="javascript:window.location.reload(true)">window.location.reload(true)</a></li>
</ul>
"""


myLinks = {
  link:
    title: "iframe buster test"
    url: "iframeTest.html"
  link:
    title: "class 'no-tracking' no tracking test"
    url: "#/no-tracking"
  link:
    title: "Latest master.zip"
    url: "https://github.com/px/cfapp-piwik-analytics/archive/master.zip"
  link:
    title: "File I don't want to track as a download"
    url: "https://github.com/px/cfapp-piwik-analytics/archive/master.zip"
  link:
    title:"Class 'no-tracking' example_piwik_ajax.html"
    url:"example_piwik_ajax.html#/"
  link:
    url:"#/"
    title:"Class 'no-tracking' No Tracking Test"
  link:
    url:"javascript:window.location.reload(true)"
    title:"javascript:window.location.reload(true)"
}

### 
#* just be sure we have a visitor id
###
window._paq.push [->
  document.getElementById("app_change").innerHTML = "_pk_visitor_id="+window._pk_visitor_id=@getVisitorId()
  ##window._pk_visitor_id = @getVisitorId()
]


class TestApp
 console.log "TestApp"

 bootstrap : ->
     console.log "bootstrap"
     # check for loaded libraries
     yes
 

 buildPage: ->
     console.log "buildPage"
     # build page header
     # page brief
     # output page links
     document.getElementById('testing.links').innerHTML=links
     # display visitor id
     # display visitor information
     yes
 


 aLink: (url,title)->
     aLink(url,title,'testing.links')

 aLink: (url,title,element)->
     console.log "aLink " + url
     a = document.createElement('a')
     a.title = title
     a.innerHTML = title
     a.href = url
     document.getElementById(element).appendChild(a)


###
#* update_status()
#* update the testApp page with information from the passed configuration
#
###
update_status = ->
  console.log "update_status() started"
  try
    document.getElementById("app_change").innerHTML = "_pk_visitor_id='" + window._pk_visitor_id+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("_debug").innerHTML = "_debug='" + window.__CF.AJS.piwik_analytics._debug+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("default_piwik_install").innerHTML = "default_piwik_install='" + window.__CF.AJS.piwik_analytics.default_piwik_install+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("piwik_install").innerHTML = "piwik_install='" + window.__CF.AJS.piwik_analytics.piwik_install+"'"
  catch e
    console.error "ERR: " + e


  try
    document.getElementById("default_piwik_site_id").innerHTML = "default_piwik_site_id='" + window.__CF.AJS.piwik_analytics.default_piwik_site_id+"'"
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("site_id").innerHTML = "site_id='" + window.__CF.AJS.piwik_analytics.site_id+"'"
  catch e
    console.error "ERR: " + e
  try
    document.getElementById("tracking_all_subdomains").innerHTML = "tracking_all_subdomains='"  + window.__CF.AJS.piwik_analytics.tracking_all_subdomains+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("tracking_group_by_domain").innerHTML = "tracking_group_by_domain='"  + window.__CF.AJS.piwik_analytics.tracking_group_by_domain+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("tracking_all_aliases").innerHTML = "tracking_all_aliases='"  + window.__CF.AJS.piwik_analytics.tracking_all_aliases+"'"
  catch e
    console.error "ERR: " + e

  try
    document.getElementById("tracking_do_not_track").innerHTML = "tracking_do_not_track='"  + window.__CF.AJS.piwik_analytics.tracking_do_not_track+"'"
  catch e
    console.error "ERR: " + e


  #  try {
  #      document.getElementById("getTracker").innerHTML = "getTracker="+(get_tracker);
  #      } catch (e) {
  #      console.error('Testing console '+e);
  #      }
  #      
  try
    document.getElementById("paq_push").innerHTML = "paq_push='" + window.__CF.AJS.piwik_analytics.paq_push+"'"
  catch e
    console.error "ERR: " + e
  yes

timer_updated = ->
  try
    document.getElementById("timeDiv").innerHTML = "Timer updated, " + _delay
    update_status()
  catch e
    console.error "ERR: " + e

testApp = new TestApp()

testApp.bootstrap()
testApp.buildPage()


window.onload=document.getElementById("timeDiv").innerHTML = "Timer update in " + _delay+ " sec, or async onload."

## only fire on pages with AJS
if window.__CF.AJS.piwik_analytics isnt undefined
  window.onload=update_status()

  setTimeout timer_updated, 1000*_delay
  ###
# the visitor id should be displayed by at least this mark, anything slower is not really acceptable
  ###
  setTimeout( "update_status()", 10000*_delay*1)

  setTimeout( "update_status()", 10000*_delay*2)

  setTimeout( "update_status()", 10000*_delay*4)

