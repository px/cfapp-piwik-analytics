###
* This is Miniature Hipster
*  @name      Miniature Hipster
*  @version   0.0.26b
*  @author    Rob Friedman <px@ns1.net>
*  @url       <http://playerx.net>
*  @license   https://github.com/px/cfapp-piwik-analytics/raw/master/LICENSE.txt
*  @todo      TODO: look for the lines in the coffeescript source file
*
* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab
###

###
# CloudFlare.push( { paths: {'piwik_analytics': 'http://labs.variablesoftware.com/test/miniature-hipster/public/javascripts/' } } );
###

###
# CloudFlare.push( { verbose:1 } );
###

###
# piwik_analytics module definition
# stick with commas for sep
# REQUIRE:
#  piwik.js library
#  piwik_analytics/config
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
###
#

# set the performance timer
window.perfNow=window.performance.now()

CloudFlare.define 'piwik_analytics', [
  'piwik_analytics/config',
    'cloudflare/console'
],
  ( __config = {}, __console) ->
    # move to functions http://stackoverflow.com/questions/4462478/jslint-is-suddenly-reporting-use-the-function-form-of-use-strict
    # use strict javascript
    "use strict"

    # create or copy so as to not destroy the window._paq for piwik to utilize
    window._paq = window._paq || []

    # define myPiwik module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {  }

    # piwik.js library is not loaded
    _isPiwik = no

    # store the visitor id
    _visitorId = no

    # link tracking enabled by default
    _linkTracking = yes

    # _debug must be either true or null
    default_debug = true # || null
    # default piwik tracker URL
    default_piwik_install = "/piwik"
    # default piwik tracker id
    default_piwik_site_id = "1"

    # try to read the _debug, otherwise set to default
    try
      if __config._debug is undefined
        __config._debug = default_debug
        __console.log("Using test default _debug=" + default_debug )
    catch e1
      __config._debug = default_debug
      __console.error(e1)

    # try to read the piwik_install otherwise set to default
    try
      if __config.piwik_install is undefined
        __config.piwik_install = default_piwik_install
        __console.log("Using test default installation Url=\"" + default_piwik_install+"\"" )
    catch e2
      __config.piwik_install = default_piwik_install
      __console.error(e2)

    # try to read the site_id otherwise set to default id
    try
      if __config.site_id is undefined
        __config.site_id = default_piwik_site_id
        __console.log("Using test default SiteId="+ default_piwik_site_id )
    catch e3
      __config.site_id = default_piwik_site_id
      __console.error (e3)


    # if debug is enabled do stuff
    if __config._debug?
      t=window.performance.now() - window.perfNow
      __console.log("Module begin time in ms ="+t)
      # turn on verbose with CloudFlare
      CloudFlare.push( { verbose:1 } )

    # If we're debugging, say Hello, and clear localStorage
      __console.log( "Hello from the Piwik Analytics CloudFlare App!" )

    # clear localStorage is we're debuging, works next reload
      __console.log(
        "localStorage.clear() === undefined? " +
        ( window.localStorage.clear()? )
      )
    # end

    ###
# myPiwik.fetch
#   uses CloudFlare.require to fetch files specified 
#   by a passed array
    ###
    myPiwik.fetch = (u) ->
      CloudFlare.require(u)

    ###
# myPiwik.isPiwik()
#   pushes a request for piwik to set _isPiwik true once piwik.js executes
#   if it does, then it will return a yes, other no
#
    ###
    myPiwik.isPiwik = () ->
      window._paq.push [->
        _isPiwik = yes
      ]
      _isPiwik


    ###
# myPiwik.getVisitorId
# pushes a request for the Piwik VisitorId generated once piwik.js executes
# sets the _visitorId to be the id, and returns it's value
# will return the visitorId or false if piwik.js is still not loaded.
#
    ###
    myPiwik.getVisitorId = () ->
      window._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        __console.log( "_visitorId="+ _visitorId ) if __config._debug?
        _visitorId
      ]
      _visitorId
      #end getVisitorId

    ###
# myPiwik.
    ###
    myPiwik.perf = () ->
      window.perfNow_piwik_js=window.performance.now()
      window._paq.push [ ->
        t=window.performance.now() - window.perfNow_piwik_js
        __console.log("Piwik library load time in ms = "+t)
        t=window.performance.now() - window.perfNow
        __console.log("Total execution time in ms = "+t)
      ]

    ###
# myPiwik.setSiteId()
#
#   checks for a null value, not a number, and assign's SiteId to default
    ###
    myPiwik.setSiteId = ( _SiteId = default_piwik_site_id , _defaultSiteId = default_piwik_site_id ) ->

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
      _SiteId

    #
    # mypiwik.setInstall
    # sets the tracker for the client to use
    #
    myPiwik.setInstall = ( _install = default_piwik_install ) ->
      if __config._debug?
        __console.log("myPiwik.setInstall = \""+_install+"\"")
        myPiwik.perf()

      window._paq.push(['setTrackerlUrl', unescape ( _install ) + "/piwik.php" ])
      # fetch the piwik library
      myPiwik.fetch([ unescape( _install + "/piwik.js" ) ])
      __console.log("end myPiwik.setInstall") if __config._debug?
      ###
      #return _install
      ###
      _install


    ###
# myPiwik.menuOpts
    ###
    myPiwik.menuOpts = ->
      if __config._debug?
        __console.log("myPiwik.menuOpts")
        perfNow=window.performance.now()

      # determine if tracking-all-subdomains is enabled -- FIXME
      if ( __config.tracking_all_subdomains is "true" or __config.tracking_all_subdomains is undefined )
        wildcardZone="*"+".example.com" ## FIXME
        window._paq.push(["setCookieDomain", wildcardZone])
      # end if tracking all subdomains


      # determine if DoNotTrack is enabled, default to obey if undefined
      if ( __config.tracking_do_not_track is "true" or __config.tracking_do_not_track is undefined )
        window._paq.push(['setDoNotTrack',true])
      else
        window._paq.push(['setDoNotTrack',false])
      # end if do_not_track

      if __config._debug?
        t=window.performance.now() - perfNow
        __console.log("end myPiwik.menuOpts " + "time in ms ="+t)

      yes

    ###
# myPiwik.paqPush()
#     take options from a Piwik configuration
#       We could have multiple trackers someday! TODO
#      It's easy, just not supported in this App.
#    push our Piwik options into the window._paq array
#     send a trackPageView to the TrackerUrl
    ###
    myPiwik.paqPush = ( ) ->
      if __config._debug?
        __console.log("myPiwik.paqPush")
        perfNow=window.performance.now()

      window._paq = window._paq || []
      # setSiteId
      myPiwik.setSiteId( __config.site_id, __config.default_site_id )
      # setInstall
      myPiwik.setInstall( __config.piwik_install )
      # menuOpts
      myPiwik.menuOpts()
      # pass the extra options if any are configured or allowed
      if (( ! __config.paq_push ) and ( __config.paq_push isnt undefined ) and ( __config.paq_push isnt ""))
        window._paq.push( __config.paq_push )

      # enable link tracking
      window._paq.push(['enableLinkTracking',true])

      # Send a trackPageView request to the TrackerUrl
      window._paq.push( ['trackPageView'] )

      if __config._debug?
        t=window.performance.now() - perfNow
        __console.log("end myPiwik.paqPush "+"time in ms ="+t)
    #rern the _paq array
      window._paq
    # end myPiwik.paqPush

    ###
    window.CloudFlare.require(['https://cdnjs.cloudflare.com/ajax/libs/piwik/1.11.1/piwik.js'], function() {
     window.console.log("piwik.js Module execution time in ms =")
     window.console.log(window.performance.now() - window.perfNow)
     }

      );
    ###

    #
    #* do stuff to get the party started
    #
    #window._paq = window._paq || []

    if __config._debug?
      myPiwik.getVisitorId()
      
    #myPiwik.fetch(unescape ( _install ) + "/piwik.js")
    #CloudFlare.require([unescape ( default_piwik_install ) + "/piwik.js"])

    #
    # paqPush
    #  all the configured options into the window._paq array for processing
    myPiwik.paqPush()

    if __config._debug?
      t=window.performance.now() - window.perfNow
      __console.log("Module execution time in ms ="+t)

    #
    # return myPiwik
    #
    myPiwik
###
#end myPiwik module
###
window.console.log("Script load time in ms =")
window.console.log(window.performance.now() - window.perfNow)
