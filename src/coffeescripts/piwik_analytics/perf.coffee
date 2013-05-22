# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* Definition for performance module
*   provides timing method for the application
###
CloudFlare.define 'piwik_analytics/perf', [
  'cloudflare/console'
  'piwik_analytics/config'
],
  ( __cons, __conf
  ) ->

    #    __cons.log("START piwik_analytics/perf")

    module = {}

    fake={}
    fake.now =->
      new Date().getTime()
    
    windowAlias=window
    p=windowAlias.performance || windowAlias.mozPerformance ||
      windowAlias.msPerformance || windowAlias.webkitPerformance || fake

    ## start early we might have messages to display
    if __conf._debug isnt null
      CloudFlare.push( { verbose:1 } )
      windowAlias.localStorage.clear()

    ###
# now()
#  return the window.performance.now()
#  or the getTime() for less precision on
#  browsers which are older
    ###
    module.now =->
      try
        p.now()
      catch e
        __cons.error(e)
        fake.now() #new Date().getTime()

    module.perfThen = module.now()

    #__cons.log("END piwik_analytics/perf")

    module
###
# end of perf module
###

