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
  'piwik_analytics/config'
  'piwik_analytics/tracker'
],
  ( __console, __perf, __conf, __tracker ) ->
    #    __console.log("START piwik_analytics")
    
    # define myPiwik module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {}

    # set the performance function and create a timer
    # wrap in try or risk failure in some browsers
    myPiwik.perfThen=__perf.now()

    # create or copy so as to not destroy the window._paq for piwik to utilize
    # window._paq = window._paq || []

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
        __console.log( "Piwik.getVisitorId = "+ _visitorId ) if __conf._debug isnt null
        _visitorId
      ]
      _visitorId
      #end getVisitorId


    ###
# myPiwik.menuOpts
    ###
    myPiwik.menuOpts = ->
      #if __conf._debug isnt null
      #  __console.log("myPiwik.menuOpts")
      
      # determine if tracking-all-subdomains is enabled
      if (  not isNaN(__conf.tracking_all_subdomains) and
            ( __conf.tracking_all_subdomains > 1) )
        try
          # FIXME this would be much easier if I could access the zone name from within CloudFlare
          # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
          # offer a selection box, with "2nd", "3rd", "4th"
          # level sub domains options
          wildcardZone="*."+document.domain.split(".").slice( -1 * __conf.tracking_all_subdomains ).join(".")
          window._paq.push(["setCookieDomain", wildcardZone])
        catch e
          __console.error("uhoh "+e)
      # end if tracking all subdomains


      # determine if DoNotTrack is enabled, default obey if undefined
      if __conf.tracking_do_not_track isnt null
        window._paq.push(['setDoNotTrack',true])
      else
        window._paq.push(['setDoNotTrack',false])



      # maybe we can get away with just isnt null and isnt undefined.
      # tracking_group_by_domain
      if ( ( __conf.tracking_group_by_domain isnt undefined ) and
        ( __conf.tracking_group_by_domain isnt null ) )
          try
            #__console.log("2 "+unescape( __conf.tracking_group_by_domain ))
            window._paq.push( ["setDocumentTitle", eval( unescape( __conf.tracking_group_by_domain ) ) ] )
          catch e
            __console.error("uhoh "+e)



      # tracking_all_aliases -- this could/should just be fetched and possibly set in a cookie.
      if ( ( __conf.tracking_all_aliases isnt undefined ) and
        ( __conf.tracking_all_aliases isnt null ) )
          try
            #__console.log(""+unescape ( __conf.tracking_all_aliases ))
            window._paq.push( ["setDomains", __conf.tracking_all_aliases ] )
          catch e
            __console.error("uhoh "+e)


      # pass the extra advanced options if any are configured or allowed
      if ( ( __conf.paq_push isnt undefined ) and
        #( __conf.paq_push isnt "") and
        ( __conf.paq_push isnt null ) )
          try
            ## might be a better way than eval'ing unescaped variable data
            window._paq.push( eval( unescape ( __conf.paq_push ) ) )
          catch e
            __console.error("uhoh "+e)

      # enable link tracking
      window._paq.push(['enableLinkTracking',true])

      # Send a trackPageView request to the TrackerUrl
      window._paq.push( ['trackPageView'] )

      #if __conf._debug isnt null
      #  __console.log("end myPiwik.menuOpts time = "+(__perf.now() - perfThen))
      # return the window._paq array so far
      window._paq

    #__console.log("before menu opts")
    try
      # menuOpts
      myPiwik.menuOpts()
    catch e
      __console.error("uhoh "+e)

    if __conf._debug isnt null
      __console.log(
        ( __perf.now() - myPiwik.perfThen ) + " ms"+
        "\t piwik_ananlytics Factory execution time")
      
      CloudFlare.require(['piwik_analytics/showPerf'])

      #try
      #  myPiwik.getVisitorId()
      #catch e
      #  __console.error("uhoh "+e)
      
    #__console.log("END piwik_analytics")
    # return myPiwik
    myPiwik
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
