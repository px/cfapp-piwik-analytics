

CloudFlare.define "piwik_analytics/config", [], () ->
  __pkC =
    "_debug":"true"
#    "_debug":null
    "default_piwik_install":"/piwik"
    "default_site_id":"1"
    "piwik_install":"https://piwik-ssl.ns1.net"
    "site_id": "26"
    "tracking_all_subdomains":"2"
    ## This is misleading, because it modifies the title captured by Piwik
    "tracking_group_by_domain":"true"
    # 
    "tracking_all_aliases":null
    #"tracking_all_aliases":"'example.com','foo.com','bar.net'"
    #"tracking_all_aliases":"'example.com','foo.com','bar.net'"
    # obey browser do-not-track setting
    "tracking_do_not_track":null

    ## DEMONS!
    "advMenu":"true"
    #"advMenu":null
    ## STILL MORE BELOW
    # Stuff to push into the array
    #paq_push: "[function(){return 0;}],['setHeartBeatTimer',5,15],[function(){return window.console.log('getVisitorId='+this.getVisitorId());}]"


##
# piwik.js:13
# TypeError: 'undefined' is not an object (evaluating 'D[Q].apply')
# [ CLOUDFLARE ] uhoh! paq_push option=['bad array', ; stuff, " ] (SyntaxError: Unexpected token ';')
#
##
    #"paq_push": "\t    [\'setHeartBeatTimer\',5,30],\t,, [\'setLinkTrackingTimer\',250] ,,,,, [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],['this'],false-true,['that'], ,', ['trackPageView'],   , ['trackPageView'], 'bad array1'], ['bad array', ; stuff,\" ][,i&#![]],[9],"  ## -- fails, sends two trackPageViews, then bombs out in piwik.js -- TypeError: 'undefined' is not an object (evaluating 'D[Q].apply')  # -- bad array unexpected ';' token
    
    #"paq_push": "\t ['eval'], [function() {return (eval   ('alert(\"eval() is bad, what the heck?\");')); }][\'setHeartBeatTimer\',1,10],\t,,[\'setLinkTrackingTimer\',250] ,,,,, ,[ function() { return window.console.log(\'getVisitorId=\'+this.getVisitorId()); } ],   , [\'bad][,i&#![]],[9],"  ## ,

      
    #"paq_push": "\t [['fudge_brownies]],   [\'setHeartBeatTimer\',5,30],\t,, [\'setLinkTrackingTimer\',250] ,,,,, [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],['this'],false-true,['that'], ,', ['trackPageView'],   , ['trackPageView'], 'bad array1'], ['bad array', ; stuff,\" ][,i&#![]],[9],"  ## -- fails, sends two trackPageViews, then bombs out in piwik.js -- TypeError: 'undefined' is not an object (evaluating 'D[Q].apply')  # -- bad array unexpected ';' token
    
    #"paq_push": "  ,  [\'setHeartBeatTimer\',,5,30],, [\'setLinkTrackingTimer\',250] , [\'disableCookies\'] ,[ function() { return window.console.log('getVisitorId='+this.getVisitorId()); } ],false-true, invalid-shit ,,   , ['trackPageView']"  ## -- PASS
    #"paq_push": "[function(){return window.console.log('stuff');},true],['setHeartBeatTimer',5,15],"
    "paq_push": "[\'setHeartBeatTimer\',5,15],[function(){return window.console.log(\'getVisitorId=\'+this.getVisitorId());}]"
    #"paq_push":"[\'disableCookies\'],"
    #"paq_push":"[\'setLinkTrackingTimer\',250],[\'disableCookies\'],"
    #"paq_push":"[\'setLinkTrackingTimer\',250],[\'disableCookies\'],[\'setHeartBeatTimer\',2,5]"
    #"paq_push":"   [\'setHeartBeatTimer\',2,5]" ## -- works
    #"paq_push":"[\'setHeartBeatTimer\',2,5]" ## -- works
    #"paq_push": "[function(){return window.console.log('100='+(99+1));}],['setHeartBeatTimer',1,5]" ## -- works
    #"paq_push":"[\'bad call\'],  [\'setHeartBeatTimer\',2,5]"
    #"paq_push":"[\'bad call\'],[\'setHeartBeatTimer\',2,5]" ## fails, will not track, due to 'bad call' being undefined in piwik.jsA
    #"paq_push":"[\'this\']" ## don't allow this. -- too small
    #"paq_push":"[\'that\']" ## don't allow that. -- too small
    #"paq_push":"[\'window._paq\']"
    #"paq_push":"[\'setHeartBeatTimer\',2,5],[function(){return window.console.log('100='+(99+1));}]" ## -- works!
    
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

