# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for tracker module
*   attempts to:
*     determine a valid installation root
*     fetch and load the piwik.js library
###
CloudFlare.define 'piwik_analytics/tracker', [
  'cloudflare/console'
  #'piwik_analytics/setup'
  'piwik_analytics/config'
  'piwik_analytics/perf'
],
  ( __cons,
    #__setup,
    __conf,
    __perf
  ) ->
    #    __cons.log("START piwik_analytics/tracker")
    tracker = {}

    # store the current time
    tracker.perfThen = __perf.now()

    tracker._debug = __conf._debug

    tracker.isPiwik = no

    ## LEAVE HERE -- already lost it once.
    windowAlias=window
    windowAlias._paq = windowAlias._paq || []
    ## END

    ###
# mypiwik.setTracker
# sets the tracker for the client to use
# will use passed _install or the default or '/piwik' as a failsafe
    ###
    tracker.setTracker =
      ( _install = __conf.default_piwik_install || '/piwik' ) ->

        tracker.perfThenJs = __perf.now()
        windowAlias=window

        CloudFlare.require( [ unescape(
          #_install + "/js/") ], tracker.isPiwik = yes)
          _install + "/piwik.js") ], tracker.isPiwik = yes)

        if tracker._debug isnt null
          __cons.log(
            "Piwik Install\t=\"#{unescape( _install)}\""
          )

        windowAlias._paq.push([
          'setTrackerUrl', unescape ( _install ) + "/piwik.php"
        ])

        ###
#return _install
        ###
        _install

    ###
# tracker.setSiteId()
#
#   checks for a number value
#   and a number >=1
#   a null value, not a number, and assign's SiteId to default or '1'
    ###
    tracker.setSiteId =
      ( _SiteId ) ->

        # if it's a number use it. Double Negative,
        # will catch, alpha, and use the default above
        if ( ( not isNaN( _SiteId ) ) and ( _SiteId >= 1 ) )
          if tracker._debug isnt null
            __cons.log(
              "Piwik WebsiteId\t=\"#{ _SiteId}\""
            )
        else
          # default to default_site_id from cloudflare.json
          if tracker._debug isnt null
            __cons.error(
              "Invalid WebsiteId\t=\"#{_SiteId}\" is not a number;"+
                " defaulting to \'#{ __conf.default_piwik_site_id }\'")
            ## double secret failsafe, if the default is null, use '1'
            _SiteId = __conf.default_piwik_site_id || '1'
        # end if site_id
        windowAlias._paq.push(['setSiteId', unescape ( _SiteId ) ])
        _SiteId

    ###
    # configure with the defaults if undefined or invalid
    ###
    tracker.piwik_install = tracker.setTracker( __conf.piwik_install )

    ## in the future if the SiteId is invalid,
    # we can use the working tracker to fetch the Id based on the domain name
    tracker.site_id = tracker.setSiteId( __conf.site_id )

    if tracker._debug isnt null
      try
        __cons.log(
          "#{(__perf.now() - tracker.perfThen)} ms\t"+
          "\"piwik_analytics/tracker\" execution time"
        )
      catch e
        __cons.error("uhoh "+e)

    #__cons.log("END piwik_analytics/tracker")
    tracker
###
# end of tracker module
###

