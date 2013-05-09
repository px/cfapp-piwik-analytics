# This is Miniature Hipster
# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
# piwik_analytics module definition
# REQUIRE:
#   -- defaults to {} and will assign test defaults
#  cloudflare/console for output to console
###

CloudFlare.define 'piwik_analytics', [
  'cloudflare/console'
  'piwik_analytics/perf'
  'piwik_analytics/setup'
  'piwik_analytics/tracker'
],
  ( __console, __perf, __setup, __tracker ) ->
    #    __console.log("START piwik_analytics")

    #try
    #  if __setup._debug isnt null
    #    __console.log(
    #      ( __perf.now() - __setup.perfThen ) + " ms"+
    #      "\t since \"piwik_analytics/setup\" Factory execution time")
    #catch e
    #  __console.error("uhoh "+e)

    #try
    #  for opt in __setup
    #    __console.log("setup opt is " +opt)
    #catch e
    #  __console.error("uhoh "+e)
    
    # define myPiwik module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {}

    # set the performance function and create a timer
    # wrap in try or risk failure in some browsers
    myPiwik.perfThen=__perf.now()

    # create or copy so as to not destroy the window._paq for piwik to utilize
    window._paq = window._paq || []

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
      _visitorId=no
      window._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        __console.log( "Piwik.getVisitorId = "+ _visitorId ) if __setup._debug isnt null
        _visitorId
      ]
      _visitorId
      #end getVisitorId


    ###
# myPiwik.menuOpts
    ###
    myPiwik.menuOpts = ->
      #if __setup._debug isnt null
      #  __console.log("myPiwik.menuOpts")
      
      # determine if tracking-all-subdomains is enabled -- FIXME
      if ( __setup.tracking_all_subdomains is "true" or __setup.tracking_all_subdomains is undefined )
        try
          # FIXME this would be much easier if I could access the zone name from within CloudFlare
          # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
          wildcardZone="*"+document.domain.split(".").slice(-2).join(".") ## FIXME -- this only works for 2nd level
          window._paq.push(["setCookieDomain", wildcardZone])
        catch e
          __console.error("uhoh "+e)
      # end if tracking all subdomains

      # determine if DoNotTrack is enabled, default to obey if undefined
      if ( __setup.tracking_do_not_track is "true" or __setup.tracking_do_not_track is undefined )
        window._paq.push(['setDoNotTrack',true])
      else
        window._paq.push(['setDoNotTrack',false])
      # end if do_not_track
      
      # tracking_group_by_domain
      if ( ( __setup.tracking_group_by_domain isnt undefined ) and
        ( __setup.tracking_group_by_domain isnt "" ) )
          try
            #__console.log("2 "+unescape( __setup.tracking_group_by_domain ))
            window._paq.push( ["setDocumentTitle", eval( unescape( __setup.tracking_group_by_domain ) ) ] )
          catch e
            __console.error("uhoh "+e)


      # tracking_all_aliases
      if ( ( __setup.tracking_all_aliases isnt undefined ) and
        ( __setup.tracking_all_aliases isnt "") )
          try
            #__console.log(""+unescape ( __setup.tracking_all_aliases ))
            window._paq.push( ["setDomains", eval( unescape ( __setup.tracking_all_aliases ) ) ] )
          catch e
            __console.error("uhoh "+e)

      # pass the extra options if any are configured or allowed
      if ( ( __setup.paq_push isnt undefined ) and
        ( __setup.paq_push isnt "") )
          try
            ## might be a better way than eval'ing unescaped variable data
            window._paq.push( eval( unescape ( __setup.paq_push ) ) )
          catch e
            __console.error("uhoh "+e)
      #if __setup._debug isnt null
      #  __console.log("end myPiwik.menuOpts time = "+(__perf.now() - perfThen))
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
      #if __setup._debug isnt null
      #  __console.log("myPiwik.paqPush")
      #  perfThen=__perf.now()

      # we do this at the top of the module
      #window._paq = window._paq || []

      # enable link tracking
      window._paq.push(['enableLinkTracking',true])

      # Send a trackPageView request to the TrackerUrl
      window._paq.push( ['trackPageView'] )

      #if __setup._debug isnt null
      #  __console.log("end myPiwik.paqPush time = "+(__perf.now() - perfThen))

    #return the _paq array
      window._paq
    # end myPiwik.paqPush

    #
    #* do stuff to get the party started
    #__console.log("before opts")

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

    if __setup._debug isnt null
      __console.log(
        ( __perf.now() - myPiwik.perfThen ) + " ms"+
        "\t piwik_ananlytics Factory execution time")
      
      CloudFlare.require(['piwik_analytics/showPerf'])


      # this getVisitorId() has to be executed last
      try
        myPiwik.getVisitorId()
      catch e
        __console.error("uhoh "+e)
    #__console.log("END piwik_analytics")
    # return myPiwik
    myPiwik
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
