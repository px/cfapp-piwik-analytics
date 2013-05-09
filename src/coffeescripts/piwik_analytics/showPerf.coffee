# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for performance
###
CloudFlare.define 'piwik_analytics/showPerf', [
  'cloudflare/console'
  'piwik_analytics/setup'
  'piwik_analytics/perf'
  'piwik_analytics/tracker'
],
  ( __console,
    __setup,
    __perf,
    __tracker
  ) ->

    #    __console.log("START piwik_analytics/showPerf")

    module = {}

    module.perfThen = __perf.now()

    module._debug = __setup._debug
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
            (__perf.now() - __tracker.perfThenJs) + " ms"+
            "\t Piwik library fetch/execute time")
        catch e
          __console.error("uhoh "+e)

        try
          __console.log(
            (__perf.now() - __perf.perfThen) + " ms"+
            "\t Total execution time")
        catch e
          __console.error("uhoh "+e)

        yes
      ]
      # return yes
      yes

    if module._debug isnt null
      module.showPerf()
      __console.log(
        (__perf.now() - module.perfThen) + " ms"+
        "\t piwik_analytics/showPerf Factory execution time")
    # __console.log("END piwik_analytics/showPerf")

    module
###
# end of perf module
###

