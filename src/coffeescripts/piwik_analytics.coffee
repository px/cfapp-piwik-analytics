# This is Miniature Hipster
# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
# piwik_analytics module definition
# stick with commas for sep
# REQUIRE:
#  piwik_analytics/config
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
#  piwik.js library -- needs logic :(
###

CloudFlare.define 'piwik_analytics', [
  'cloudflare/console'
  'piwik_analytics/perf'
  'piwik_analytics/setup'
  'piwik_analytics/piwik_js'
],
  ( __console, __perf, __setup, __js ) ->
    # move to functions FIXME http://stackoverflow.com/questions/4462478/jslint-is-suddenly-reporting-use-the-function-form-of-use-strict
    #    __console.log("START piwik_analytics")

    #__console.log("try setup()")
    # this
    try
      #      __setup(__config)
    catch e
      __console.error("uhoh "+e)

    __config = {}

    # should be avoided, but for whatever reason, the __setup is not there when it needs to be
    #CloudFlare.block(['piwik_analytics/setup'])

    #try
    #  for opt in __setup
    #    __console.log("setup opt is " +opt)
    #catch e
    #  __console.error("uhoh "+e)

    try
      _debug = __setup._debug || yes
    catch e
      __console.error("uhoh "+e)

    ### 
# now()
#  return the window.performance.now()
#  or the getTime() for less precision on
#  browsers which are older
    ###
    now =->
      fake={}
      fake.now =->
         new Date().getTime()

      p=window.performance || window.mozPerformance ||
        window.msPerformance || window.webkitPerformance || fake
      try
        p.now()
      catch e
        window.console.log(e)
        fake.now() #new Date().getTime()

    # define myPiwik module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {}

    # set the performance function and create a timer
    # wrap in try or risk failure in some browsers
    myPiwik.perfThen=__perf.now()

    # create or copy so as to not destroy the window._paq for piwik to utilize
    window._paq = window._paq || []


    #__console.log(_debug + " valued")
    # if debug is enabled do stuff
    if _debug?
      # turn on verbose with CloudFlare
      CloudFlare.push( { verbose:1 } )

      # If we're debugging, say Hello, and clear localStorage
      __console.log( "Hello from the Piwik Analytics CloudFlare App!" )

      #__console.log( (__perf.now() - __setup.perfThen ) + " ms" + "\t since piwik_analytics/setup begin execution time" )

      # clear localStorage is we're debuging, works next reload
      #__console.log(
      #  "localStorage.clear() === undefined? " +
      #  ( window.localStorage.clear()? )
      #)
      window.localStorage.clear()
    # end

    ##
# myPiwik.isPiwik()
#   pushes a request for piwik to set _isPiwik true once piwik.js executes
#   if it does, then it will return a yes, other no
#
    ##
#    myPiwik.isPiwik = () ->
#      # use strict javascript
#      #"use strict"
#      window._paq.push [->
#        _isPiwik = yes
#      ]
#      _isPiwik


    ###
# myPiwik.getVisitorId
# pushes a request for the Piwik VisitorId generated once piwik.js executes
# sets the _visitorId to be the id, and returns it's value
# will return the visitorId or false if piwik.js is still not loaded.
#
    ###
    myPiwik.getVisitorId = () ->
      #"use strict"
      window._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        __console.log( "_visitorId = "+ _visitorId ) if _debug?
        _visitorId
      ]
      _visitorId
      #end getVisitorId


    ###
# myPiwik.menuOpts
    ###
    myPiwik.menuOpts = ->
      if _debug?
        __console.log("myPiwik.menuOpts")
      #  perfThen=now()
      
      # determine if tracking-all-subdomains is enabled -- FIXME
      if ( __config.tracking_all_subdomains is "true" or __config.tracking_all_subdomains is undefined )
        # FIXME this would be much easier if I could access the zone name from within CloudFlare
        # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
        wildcardZone="*"+document.domain.split(".").slice(-2).join(".") ## FIXME -- this only works for 2nd level
        window._paq.push(["setCookieDomain", wildcardZone])
      # end if tracking all subdomains

      # determine if DoNotTrack is enabled, default to obey if undefined
      if ( __config.tracking_do_not_track is "true" or __config.tracking_do_not_track is undefined )
        window._paq.push(['setDoNotTrack',true])
      else
        window._paq.push(['setDoNotTrack',false])
      # end if do_not_track

      #if _debug?
      #  __console.log("end myPiwik.menuOpts time = "+(now() - perfThen))
      # return the window._paq array so far
      window._paq

    ###
# myPiwik.paqPush()
#     take options from a Piwik configuration
#       We could have multiple trackers someday! TODO
#      It's easy, just not supported in this App.
#    push our Piwik options into the window._paq array
#     send a trackPageView to the TrackerUrl
    ###
    myPiwik.paqPush = ( ) ->
      #if _debug?
      #  __console.log("myPiwik.paqPush")
      #  perfThen=now()

      # we do this at the top of the module
      #window._paq = window._paq || []
      # pass the extra options if any are configured or allowed
      if ( ( ! __config.paq_push ) and
        ( __config.paq_push isnt undefined ) and
        ( __config.paq_push isnt "") )
          window._paq.push( unescape (__config.paq_push) )

      # enable link tracking
      window._paq.push(['enableLinkTracking',true])

      # Send a trackPageView request to the TrackerUrl
      window._paq.push( ['trackPageView'] )

      #if _debug?
      #  __console.log("end myPiwik.paqPush time = "+(now() - perfThen))

    #return the _paq array
      window._paq
    # end myPiwik.paqPush


    #
    #* do stuff to get the party started
    #__console.log("before opts")

    if _debug?
      myPiwik.getVisitorId()

    #__console.log("before menu opts")
    try
      # menuOpts
      myPiwik.menuOpts()
    catch e
      __console.error("uhoh "+e)

    #__console.log("before paqPush")
    
    try
      # paqPush
      #  all the configured options into the window._paq array for processing
      myPiwik.paqPush()
    catch e
      __console.error("uhoh "+e)

    if _debug?
      __console.log(
        ( now() - __setup.perfThen ) + " ms"+
        "\t since __setup Module execution time")
      __console.log(
        ( now() - myPiwik.perfThen ) + " ms"+
        "\t piwik_ananlytics Factory execution time")

    #__console.log("END piwik_analytics")

    #
    # return myPiwik
    #
    myPiwik
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
