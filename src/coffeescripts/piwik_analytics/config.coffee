

CloudFlare.define "piwik_analytics/config", [], () ->
  __pkC =
    "_debug":"true"
    "site_id": "26"
    "piwik_install":null
    "default_piwik_install":"https:\/\/piwik-ssl.ns1.net"
    "default_site_id":"1"
    # whether or not to track outlinks
    link_tracking: "true"
    "piwik_tracker":"https://piwik-ssl.ns1.net"
    "tracking_all_subdomains":null
    "tracking_group_by_domain":"document.domain + '\/' + document.title"
    "tracking_all_aliases":"[\"*.variablesoftware.com\",\"variablesoftware.com\"]"
    # obey browser do-not-track setting
    "set_obey_do_not_track":null
    # Stuff to push into the array
    paq_push: "[\'setLinkTrackingTimer\',250],[\'disableCookies\']"

    #default_piwik_version: "1.10.1"
    #default_piwik_js: "https://cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js"
    #cdnjs: "//cdnjs.cloudflare.com/ajax/libs"

    # "our piwik host"
    #js_prot: "https:"
    #js_schem: "//"
    #js_host: "piwik-ssl.ns1.net"
    #js_path: "/"
    #js_file: "piwik.js"
    #js_url: ""

    #  "js_url" : js_host+js_path+js_file,

    # Trackers
    #tracker: "//piwik-ssl.ns1.net/piwik.php"

    #"a" : "['setLinkTrackingTimer',250],['setHeartBeatTimer',15,30],['disableCookies']",
    #b: "['setLinkTrackingTimer',250],['trackGoal',1,0],['killFrame']"
    # link tracking timer for how long to wait
#    link_tracking_timer: "500"

#  ,
#   "goal": {
#
#"a" : { "1" : "", "2" : "", "3" :"" },
#"b" : { "1" : "", "2" : "", "3" :"" },
#
#  } 

# can't "build" this in the above associative array
#  __pkC.js_url = __pkC.js_prot + __pkC.js_schem + __pkC.js_host + __pkC.js_path + __pkC.js_file
#console.log pkC.default_piwik_js
# be lazy, copy it over from the short name to one that makes more sense.
  return window.__piwikConfig = __pkC
