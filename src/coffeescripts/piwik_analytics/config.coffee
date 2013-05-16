

CloudFlare.define "piwik_analytics/config", [], () ->
  __pkC =
    "_debug":"true"
    "default_piwik_install":"/piwik"
    "default_site_id":"1"
    "piwik_install":"https://piwik-ssl.ns1.net"
    "site_id": "26"
    # whether or not to track outlinks
    "link_tracking": "true"
    "tracking_all_subdomains":"2"
    ## This is misleading, because it modifies the title captured by Piwik
    "tracking_group_by_domain":"true"
    #
    "tracking_all_aliases":"true"
    # obey browser do-not-track setting
    "tracking_do_not_track":null
    # Stuff to push into the array
    #paq_push: "[function(){return 0;}],['setHeartBeatTimer',5,15],[function(){return window.console.log('getVisitorId='+this.getVisitorId());}]"

    "paq_push": "\t    [\'setHeartBeatTimer\',5,30],\t,, [\'setLinkTrackingTimer\',250] ,,,,, [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],['this'],false-true,['that'],    , ['trackPageView'], 'bad array1'], ['bad array', ; stuff,\" ][,i&#![]],[9],"  ## -- fails
    "paq_push": "  ,  [\'setHeartBeatTimer\',,5,30],, [\'setLinkTrackingTimer\',250] , [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],false-true, invalid-shit ,,   , ['trackPageView']"
    #"paq_push": "[function(){return window.console.log('stuff');},true],['setHeartBeatTimer',5,15],"
    #"paq_push": "[\'setHeartBeatTimer\',5,15],[function(){return window.console.log(\'getVisitorId=\'+this.getVisitorId());}]"
    #"paq_push":"['setLinkTrackingTimer',250],['disableCookies'],[\'setHeartBeatTimer\',2,5]"
    #"paq_push":"   [\'setHeartBeatTimer\',2,5]" ## -- works
    #"paq_push":"[\'setHeartBeatTimer\',2,5],  " ## -- works
    #"paq_push":"[\'setHeartBeatTimer\',2,5]" ## -- works
    #"paq_push": "[function(){return window.console('100='+99+1);}],['setHeartBeatTimer',5,15]"
    #"paq_push":"['bad call'],  [\'setHeartBeatTimer\',2,5]"
    #"paq_push":"['bad call'],[\'setHeartBeatTimer\',2,5]"
    #"paq_push":null
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

