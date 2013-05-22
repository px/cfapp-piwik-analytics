# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for performance display
###
CloudFlare.define 'piwik_analytics/showPerf', [
  'cloudflare/console'
  'piwik_analytics/config'
  'piwik_analytics/perf'
  'piwik_analytics/tracker'
],
  ( __cons,
    __conf,
    __perf,
    __tracker
  ) ->

    #    __cons.log("START piwik_analytics/showPerf")

    module = {}

    module.perfThen = __perf.now()

    module._debug = __conf._debug
    ###
# showPerf
#   Use the _paq array to push functions which
#   display performance metrics
#   with the Javascript console once piwik.js is loaded.
    ###
    module.showPerf = () ->

      window._paq.push [ ->
        try
          __cons.log(
            (__perf.now() - __tracker.perfThenJs) + " ms"+
            "\tPiwik library fetch/exec time")
        catch e
          __cons.error("uhoh "+e)

        try
          __cons.log(
            (__perf.now() - __perf.perfThen) + " ms"+
            "\tTotal exec time")
        catch e
          __cons.error("uhoh "+e)

        yes
      ]
      # return yes
      yes

    if module._debug isnt null
      module.showPerf()
      __cons.log(
        (__perf.now() - module.perfThen) + " ms"+
        "\t\"piwik_analytics/showPerf\" time")
    # __cons.log("END piwik_analytics/showPerf")

    module
###
# end of perf module
###

