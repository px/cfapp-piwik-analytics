#"use strict"

# document = document || [];
window._paq = window._paq || []
#_paq.push([ function() { get_tracker = this.getAsyncTracker(); }]);

_debug = _debug or true

get_tracker = "default tracker"


_delay = 1.0


links = """
<!-- convert to some other file of links to utilize between the other test files. -->
  <ul>
    <li><a href="iframeTest.html">iframe buster test</a></li>
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
  link1:
    title: "iframe buster test"
    url: "iframeTest.html"
  link2:
    title: "class 'no-tracking' no tracking test"
    url: "#/no-tracking"
  link3:
    title: "Latest master.zip"
    url: "https://github.com/px/cfapp-piwik-analytics/archive/master.zip"
  link4:
    title: "File I don't want to track as a download"
    url: "https://github.com/px/cfapp-piwik-analytics/archive/master.zip"
  link5:
    title:"Class 'no-tracking' example_piwik_ajax.html"
    url:"example_piwik_ajax.html#/"
  link6:
    url:"#/"
    title:"Class 'no-tracking' No Tracking Test"
  link7:
    url:"javascript:window.location.reload(true)"
    title:"javascript:window.location.reload(true)"
}


class TestApp
 console.log "TestApp"

 buildPage: ->
   # build page header
   # page brief
   # output page links
   document.getElementById('testing.links').innerHTML=links
   # display visitor id
   # display visitor information


 bootstrap: ->
  # check for loaded libraries
  yes

 aLink: (url,title)->
   aLink(url,title,'testing.links')

 aLink: (url,title,element)->
    a = document.createElement('a')
    a.title = title
    a.innerHTML = title
    a.href = url
    document.getElementById(element).appendChild(a)

window.onload=document.getElementById("timeDiv").innerHTML = "Timer update in " + _delay+ " sec, or async onload."

window.piwikConfig = window.piwikConfig or {}
window._paq.push [->
  window._pk_visitor_id = @getVisitorId()
]

#myVar = setTimeout ->
#  update_status()
#  1000*_delay


###
#* update_status()
#* update the testApp page with information from the passed configuration
#
###
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


testApp = new TestApp()

testApp.bootstrap()
testApp.buildPage()


window.onload=update_status()

