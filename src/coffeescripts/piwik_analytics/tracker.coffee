# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for tracker
###
CloudFlare.define 'piwik_analytics/tracker', [
  'cloudflare/console'
  'piwik_analytics/setup'
  'piwik_analytics/perf'
],
  ( __console,
    __conf,
    __perf
  ) ->
    #    __console.log("START piwik_analytics/tracker")
    tracker = {}

    # store the current time
    tracker.perfThen = __perf.now()

    tracker._debug = __conf._debug
    ###
# tracker.setSiteId()
#
#   checks for a null value, not a number, and assign's SiteId to default
    ###
    tracker.setSiteId =
      ( _SiteId ) ->

        __conf.setDefault( _SiteId, __conf.default_piwik_site_id, "WebsiteId" )

        # if it's a number use it. Double Negative,
        # will catch, alpha, and use the default above
        if ( ( not isNaN( _SiteId ) ) and ( _SiteId >= 1 ) )
          __console.log( "tracker.setSiteId\t = "+ _SiteId ) if __conf._debug?
        else
          # default to default_site_id from cloudflare.json
          __console.error( "Invalid WebsiteId = \'"+ _SiteId+
            "\' is not a number; defaulting to \'" + ( __conf.default_piwik_site_id ) + "\'") if tracker._debug?
          _SiteId = __conf.default_piwik_site_id
        # end if site_id
        window._paq.push(['setSiteId', unescape ( _SiteId ) ])
        _SiteId

    ###
# mypiwik.setTracker
# sets the tracker for the client to use
    ###
    tracker.setTracker =
      (_install ) ->

        _install = __conf.setDefault( _install, __conf.default_piwik_install, "Install" )

        if tracker._debug?
          __console.log("tracker.setTracker\t = \""+unescape( _install)+"\"")

        window._paq.push([
          'setTrackerUrl', unescape ( _install ) + "/piwik.php"
        ])
        ###
#return _install
        ###
        _install

    ###
    # configure with the defaults if undefined or invalid
    ###
    #__console.log("install "+__conf.piwik_install)
    #__console.log("site_id "+__conf.site_id)
    tracker.piwik_install = tracker.setTracker( __conf.piwik_install )

    try
      ## in the future if the SiteId is invalid,
      # we can use the working tracker to fetch the Id based on the domain name
      tracker.site_id = tracker.setSiteId( __conf.site_id )
    catch e
      __console.error("uhoh "+e)
    #__console.log( "Hello from the Piwik Analytics CloudFlare App!" )

    if tracker._debug?
      CloudFlare.push( { verbose:1 } )
      window.localStorage.clear()
    #__console.log("END piwik_analytics/tracker")

    try
      __console.log(
        (__perf.now() - tracker.perfThen) + " ms"+
          "\t piwik_analytics/tracker execution time")
    catch e
      __console.error("uhoh "+e)

    tracker
###
# end of tracker module
###

