# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for piwik_js
###
CloudFlare.define 'piwik_analytics/piwik_js', [
  'piwik_analytics/setup'
  'cloudflare/console'
  'piwik_analytics/perf'
],
  ( __setup , __console, __perf) ->

    #__console.log("START piwik_analytics/piwik_js")
    # module object
    module = {}

    # piwik.js library is not loaded
    module._isPiwik = no
    
    #__console.log("isPiwik " + module._isPiwik)
    
    module.perfThen = __perf.now()
    
    # perform the fetch '/piwik.js' on the configured installation url
    CloudFlare.require(
      [ unescape( __setup.piwik_install + "/piwik.js" ) ],
      module.isPiwik = yes
    )
    #__console.log("isPiwik " + module._isPiwik)

    try
      __console.log(
         (__perf.now() - module.perfThen) + " ms"+
         "\t piwik_analytics/piwik_js execution time")
    catch e
      __console.error("uhoh "+e)

    #__console.log("END piwik_analytics/piwik_js")
    # return piwik_js module
    module

###
* end of piwik_js module
###
