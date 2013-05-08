# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for performance
###
CloudFlare.define 'piwik_analytics/showPerf', [
  'cloudflare/console'
  'piwik_analytics/setup'
  'piwik_analytics/perf'
  'piwik_analytics/piwik_js'
],
  ( __console,
    __setup,
    __perf,
    __js
  ) ->

    #    __console.log("START piwik_analytics/showPerf")

    module = {}
    ###
# showPerf
#   Use the _paq array to push functions which
#   display performance metrics
#   with the Javascript console once piwik.js is loaded.
    ###
    module.showPerf = () ->

      window._paq.push [ ->
        try
          __console.log(
            (__perf.now() - __js.perfThen) + " ms"+
            "\t Piwik library fetch/execute time")
        catch e
          __console.error("uhoh "+e)

        try
          __console.log(
            (__perf.now() - __setup.perfThen) + " ms"+
            "\t Total execution time")
        catch e
          __console.error("uhoh "+e)

        yes
      ]
      # return yes
      yes

    if __setup._debug?
      module.showPerf()

    # __console.log("END piwik_analytics/showPerf")

    module
###
# end of perf module
###

