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
    # # done in tracker module
    # window._paq = window._paq || []

    ## paq push
    # push array objects into window._paq with error catching
    pp = (ao) =>
      try
        t=window._paq.push(ao)
        if __conf._debug
          __console.log("_paq.length="+t+",\t _paq.push "+ao+" ")
      catch error
        __console.error("uhoh! pp "+error)

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
      # check for a number, and an arbitray range between 2 and 15.
      if ( not isNaN( __conf.tracking_all_subdomains ) and
        ( __conf.tracking_all_subdomains > 1 ) and
            ( __conf.tracking_all_subdomains <= 15 ) )

        # FIXME this would be much easier if I could access the zone name from within CloudFlare
        # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
        # WORKING -- offer a selection box, with "2nd", "3rd", "4th"
        # level sub domains options
        wildcardZone="*."+document.domain.split(".").slice( -1 * __conf.tracking_all_subdomains ).join(".")
        #__console.log("setCookieDomain="+wildcardZone) if __conf._debug

        #
        pp(["setCookieDomain", wildcardZone])
        #window._paq.push(["setCookieDomain", wildcardZone])
        # end if tracking all subdomains


      # determine if DoNotTrack is enabled, default obey if undefined
      if __conf.tracking_do_not_track isnt null
        pp(['setDoNotTrack',true])
      else
        pp(['setDoNotTrack',false])


      # maybe we can get away with just isnt null and isnt undefined.
      # tracking_group_by_domain
      if ( ( __conf.tracking_group_by_domain isnt undefined ) and
        ( __conf.tracking_group_by_domain isnt null ) )
          #__console.log("2 "+unescape( __conf.tracking_group_by_domain ))
          pp( ["setDocumentTitle", document.domain + ' / ' + document.title ] )



      # tracking_all_aliases -- this could/should just be fetched and possibly set in a cookie.
      if ( ( __conf.tracking_all_aliases isnt undefined ) and
        ( __conf.tracking_all_aliases isnt null ) )
          try
            #__console.log(""+unescape ( __conf.tracking_all_aliases ))
            pp(["setDomains", __conf.tracking_all_aliases ] )
          catch e
            __console.error("uhoh "+e)

      # pass the extra advanced options if any are configured or allowed
      if ( ( __conf.paq_push isnt undefined ) and
        ( __conf.paq_push isnt null ) )
          index=1
          fixspaces=/\s{2,}/g
          # group matching ( zero or more spaces leading spaces before a comma)
          # two or more of these 
          doublecomma=/(\s{0,}\,){2,}/g #\s{0,}\,/g
          trailingcomma=/\,$/
          # split on end
          #pattern=/\]\s?,\s?/
          # split on begin of array, zero or more preceeding whitespace, comma, white space, open square bracket
          pattern=/\s{0,}\,{0,}\s?\[/g
          ## object
          obj=(__conf.paq_push)
          __console.log obj
          obj=obj.replace(doublecomma, ", ")
          __console.log obj
          # close square, one or more space, comma, to '] '
          obj=obj.replace(/\]\s{0,}\,/g , '], ')
          __console.log obj
          obj=obj.replace(fixspaces, ' ')
          __console.log obj
          last=obj.length
          ## loop over the configured options
          for option in obj.split(pattern)
            #__console.log(index+" option='"+option+"'") if __conf._debug
            ## might be a better way than...
            ##  eval'ing unescaped variable data surrounded
            if option isnt ""
              option.replace( trailingcomma, '')
              #option.replace(/,$/,'')
              #if index isnt last # (__conf.paq_push).split('],').length
              #  __console.log (index)
                #  ## we don't need to fix the last one.
                #option+=']'
              option='['+option
              #if ( index >= last-2 )
              #option.replace(/\],$/,']')
              #remove trailing comma
              #__console.log(index+" option='"+option+"'") if __conf._debug
              try
                #__console.log (" "+ (typeof eval(option)))

                pp( eval (option) )
              catch e
                __console.error("uhoh! paq_push option="+option+" ("+e+")")
            index++

      #window._paq.push(['setHeartBeatTimer',5,15])

      # enable link tracking
      pp(['enableLinkTracking',true])

      # Send a trackPageView request to the TrackerUrl
      pp( ['trackPageView'] )

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

    #__console.log("END piwik_analytics")
    # return myPiwik
    myPiwik
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
