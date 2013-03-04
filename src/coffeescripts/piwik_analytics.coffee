###
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @version   0.0.22b
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*  @todo      TODO:
*
* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab
###

###
# CloudFlare.push( { paths: {'piwik_analytics': 'http://labs.variablesoftware.com/test/miniature-hipster/public/javascripts/' } } );
# CloudFlare.push( { paths: {'piwik_analytics/config': 'http://labs.variablesoftware.com/test/miniature-hipster/public/' } } );
###

###
# CloudFlare.push( { verbose:1 } );
###

###
# piwik_analytics module definition
# stick with commas for sep
# REQUIRE:
#  piwik.js library
#
#  piwik_analytics/config
#  cloudflare/console for output to console
###

CloudFlare.define 'piwik_analytics', [
    '//cdnjs.cloudflare.com/ajax/libs/piwik/1.10.1/piwik.js',
    'piwik_analytics/config',
    'cloudflare/console'
],
  ( __piwik_js, __config = {}, __console ) ->

    "use strict"

    # create or copy so as to not destroy the window._paq for piwik to utilize
    window._paq = window._paq || []
   
    if __config._debug?
    # If we're debugging, say Hello, and clear localStorage
      __console.log( "Hello from the Piwik CloudFlare App!" )
    # clear localStorage is we're debuging
      __console.log(
        "localStorage.clear() === undefined? " +
        ( window.localStorage.clear()? )
      )
    # end

    # myPiwik module
    #to be passed into a "return" later which will cause loading
    myPiwik = {  }

    # piwik.js library is not loaded
    _isPiwik = no

    # store the visitor id
    _visitorId = no

    # link tracking enabled by default
    _linkTracking = yes

    default_debug = null
    default_piwik_tracker = "/piwik/piwik.php"
    default_piwik_site_id = "1"

    try
      if __config._debug is undefined
        __config._debug = default_debug
        __console.log("Using test default _debug=" + default_debug )
    catch e
      __config._debug = default_debug
      __console.error(e)

    try
      if __config.piwik_tracker is undefined
        __config.piwik_tracker = default_piwik_tracker
        __console.log("Using test default TrackerUrl=" + default_piwik_tracker )
    catch e
      __config.piwik_tracker = default_piwik_tracker
      __console.error(e)

    try
      if __config.site_id is undefined
        __config.site_id = default_piwik_site_id
        __console.log("Using test default SiteId="+ default_piwik_site_id )
    catch e
      __config.site_id = default_piwik_site_id
      __console.error (e)

#
# myPiwik.isPiwik()
#   pushes a request for piwik to set _isPiwik true once piwik.js executes
#   if it does, then it will return a yes, other no
#
    #
    myPiwik.isPiwik = () ->
      window._paq.push [->
        _isPiwik = yes
      ]
      _isPiwik


    #
# myPiwik.getVisitorId
# pushes a request for the Piwik VisitorId generated once piwik.js executes
# sets the _visitorId to be the id, and returns it's value
# will return the visitorId or false if piwik.js is still not loaded.
#
    #
    myPiwik.getVisitorId = () ->
      window._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        __console.log( "_visitorId="+ _visitorId ) if __config._debug?
        _visitorId
      ]
      _visitorId
      #end getVisitorId

    #
# myPiwik.setSiteId()
#
#   checks for a null value, not a number, and assign's SiteId to default
    #
    myPiwik.setSiteId = ( _SiteId = "1",  _defaultSiteId = "1" ) ->
      __console.log("myPiwik.setSiteId") if __config._debug?
      # if it's a number use it. Double Negative,
      # will catch, alpha, and use the default above
      if ( not isNaN( _SiteId ) )
        __console.log( "Using _SiteId="+ _SiteId ) if __config._debug?
      else
        # default to default_site_id from cloudflare.json
        __console.error( "Invalid SiteId="+ _SiteId+
          " ; defaulting to " + _defaultSiteId ) if __config._debug?
        _SiteId = _defaultSideId
      # end if site_id
      window._paq.push(['setSiteId', unescape ( _SiteId ) ])
      __console.log("end myPiwik.setSiteId") if __config._debug?
      _SiteId

    #
    # mypiwik.setTracker
    # sets the tracker for the client to use
    #
    myPiwik.setTracker = ( _tracker ="/piwik/piwik.php" ) ->
      __console.log("myPiwik.setTracker") if __config._debug?
      window._paq.push(['setTrackerUrl', unescape ( _tracker ) ])
      __console.log("end myPiwik.setTracker") if __config._debug?
      ###
      #return _tracker
      ###
      _tracker


    #
    # myPiwik.menuOpts
    #
    myPiwik.menuOpts = ->
      __console.log("myPiwik.menuOpts") if __config._debug?
      # determine if LinkTracking is enabled, default to enable if undefined
      if ( __config.link_tracking is "true" or __config.link_tracking is undefined )
        window._paq.push(['enableLinkTracking',true])
      else
        window._paq.push(['enableLinkTracking',false])
      # end if link_tracking

      # determine if DoNotTrack is enabled, default to obey if undefined
      if ( __config.set_obey_do_not_track is "true" or __config.set_obey_do_not_track is undefined )
        window._paq.push(['setDoNotTrack',true])
      else
        window._paq.push(['setDoNotTrack',false])
      # end if do_not_track
      __console.log("end myPiwik.menuOpts") if __config._debug?
      yes

    #
# myPiwik.paqPush()
#     take options from a Piwik configuration
#       We could have multiple trackers someday! TODO
#      It's easy, just not supported in this App.
#    push our Piwik options into the window._paq array
#     send a trackPageView to the TrackerUrl
    #
    myPiwik.paqPush = ( ) ->
      __console.log( "myPiwik.paqPush()" ) if __config._debug?
      window._paq = window._paq || []
    # setSiteId
      myPiwik.setSiteId( __config.site_id, __config.default_site_id )
    # setTracker
      myPiwik.setTracker( __config.piwik_tracker )
    # menuOpts
      myPiwik.menuOpts()
    # pass the extra options if any are configured or allowed
      if (( ! __config.paq_push ) and ( __config.paq_push isnt undefined ) and ( __config.paq_push isnt ""))
        window._paq.push( __config.paq_push )

    # Send a trackPageView request to the TrackerUrl
      window._paq.push( ['trackPageView'] )
      __console.log("paqPush() finished ok! _paq=" + window._paq ) if __config._debug?
    #rern the _paq array
      window._paq
    # end myPiwik.paqPush

    #
    #* do stuff to get the party started
    #
    #window._paq = window._paq || []

    myPiwik.getVisitorId()

    #
    # paqPush 
    #  all the configured options into the window._paq array for processing
    myPiwik.paqPush()
    
    #
    # return myPiwik
    #
    myPiwik
###
#end myPiwik module
###
