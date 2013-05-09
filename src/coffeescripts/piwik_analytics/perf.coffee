# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for performance module
*   provides timing resources for the rest of the application
###
CloudFlare.define 'piwik_analytics/perf', [
  'cloudflare/console'
],
  ( __console
  ) ->

    #    __console.log("START piwik_analytics/perf")

    module = {}

    fake={}
    fake.now =->
      new Date().getTime()

    p=window.performance || window.mozPerformance ||
      window.msPerformance || window.webkitPerformance || fake
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
        __console.error(e)
        fake.now() #new Date().getTime()

    module.perfThen = module.now()

    #__console.log("END piwik_analytics/perf")

    module
###
# end of perf module
###

