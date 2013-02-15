__pkC =
  default_piwik_version: "1.10.1"
  use_cdnjs: true
  default_piwik_js: "https://cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js"
  cdnjs: "//cdnjs.cloudflare.com/ajax/libs"
  
  # "our piwik host"
  js_prot: "https:"
  js_schem: "//"
  js_host: "piwik-ssl.ns1.net"
  js_path: "/"
  js_file: "piwik.js"
  js_url: ""
  
  #  "js_url" : js_host+js_path+js_file,
  # Site id's
  site_id: "26"
  
  # Trackers
  tracker: "//piwik-ssl.ns1.net/piwik.php"
  
  # Stuff to push into the array
  paq_push: "['setLinkTrackingTimer',250],['disableCookies']"
    #"a" : "['setLinkTrackingTimer',250],['setHeartBeatTimer',15,30],['disableCookies']",
    #b: "['setLinkTrackingTimer',250],['trackGoal',1,0],['killFrame']"

  # obey browser do-not-track setting
  set_do_not_track: "true"
  
  # link tracking timer for how long to wait
  link_tracking_timer: "500"
  
  # whether or not to track outlinks
  link_tracking: "true"
  
  # TODO 
  
  # set the domains to track
  set_domains: "a"
  
  # set the cookie domain for each
  set_cookie_domain:  "a"
#
#  ,
#   "goal": {
#
#"a" : { "1" : "", "2" : "", "3" :"" },
#"b" : { "1" : "", "2" : "", "3" :"" },
#
#  } 

# can't "build" this in the above associative array
__pkC.js_url = __pkC.js_prot + __pkC.js_schem + __pkC.js_host + __pkC.js_path + __pkC.js_file
#console.log pkC.default_piwik_js
# be lazy, copy it over from the short name to one that makes more sense.
window.__piwikConfig = __pkC
