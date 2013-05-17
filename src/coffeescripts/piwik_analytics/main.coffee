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
  ( __cons, __perf, __conf, __tracker ) ->
    #    __cons.log("START piwik_analytics")

    # define myPiwikAlias module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {}
    myPiwikAlias=myPiwik

    # set the performance function and create a timer
    # wrap in try or risk failure in some browsers
    myPiwikAlias.perfThen=__perf.now()

    #
    windowAlias = window
    # create or copy so as to not destroy the window._paq for piwik to utilize
    # # done in tracker module
    # windowAlias._paq = windowAlias._paq || []
    

    ## error string
    _err="uhoh! "
    
    ## paq pusher
    # push array objects into window._paq with error catching
    paqPush = (ao) =>
      windowAlias=window
      try
        size=0
        switch (typeof ao)
          when "object" then size=windowAlias._paq.push(ao)
          when "string" then size=windowAlias._paq.push([ao])

          else
            __cons.error("#{_err} -- not sure what type this is #{(typeof ao)}")

        if __conf._debug
          __cons.log("_paq.length=#{size},\t#{ao}")

      catch error
        __cons.error("#{_err} pp (#{error})")

    ##
# myPiwikAlias.isPiwik()
#   pushes a request for piwik to set _isPiwik true once piwik.js executes
#   if it does, then it will return a yes, other no
#
    ##
#    myPiwikAlias.isPiwik = () ->
#      # use strict javascript
#      #"use strict"
#      windowAlias._paq.push [->
#        _isPiwik = yes
#      ]
#      _isPiwik


    ###
# myPiwikAlias.getVisitorId
# pushes a request for the Piwik VisitorId generated once piwik.js executes
# sets the _visitorId to be the id, and returns it's value
# will return the visitorId or false if piwik.js is still not loaded.
#
    ###
    myPiwikAlias.getVisitorId = () ->
      #"use strict"
      _visitorId=no
      windowAlias=window
      windowAlias._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        __cons.log( "Piwik.getVisitorId = #{_visitorId}" ) if __conf._debug isnt null
        _visitorId
      ]
      _visitorId
      #end getVisitorId


    ###
# myPiwikAlias.advMenuOpts
    ###
    myPiwikAlias.advMenuOpts = ->
      windowAlias=window
      __cons.log("ADVANCED FEATURES BEGIN") if __conf._debug?

      _paq_push=__conf.paq_push
      # pass the extra advanced options if any are configured or allowed
      if ( ( _paq_push isnt undefined ) and
        ( _paq_push isnt null ) )
          
          index=1
          fixdoublespaces=/\s{2,}/g
          # group matching ( zero or more spaces leading spaces before a comma)
          # two or more of these 
          doublecomma=/(\s{0,}\,){2,}/g #\s{0,}\,/g
          beginningcomma=/^([\,\s\S]{0,})\[/
          trailingcomma=/\]([\,\s\S]{0,})$/
          weirdcomma=/\s?\,\s?/g
          evileval=/eval\s{0,}\(.+\)/g
          # split on end
          #pattern=/\]\s?,\s?/
          # split on begin of array
          # #, zero or more preceeding whitespace, comma, white space, open square bracket
          ##pattern=/\]\s{0,}\,{0,}\s{0,}\[/
          
          #pattern=/\s{0,}\,{0,}\s{0,}/
          pattern=/\]\s{0,}\,{0,}\s{0,}\[?/
      
          #pattern=/\]?\s{0,}\,{0,}\s{0,}\[/
          #pattern=/([\,\s]{0,}\[.+\]([\,\s]){0,})/
          #pattern=/([\,\s]{0,}\[.+\]([\,\s]))/
          #pattern=/([\,\s]{0,}\[.+\]([\,\s]){0,}){0,}/
          ## object
          obj=(_paq_push)
          __cons.log "plain \'"+obj+"\'"
          obj=obj.replace(doublecomma, ", ")
          #__cons.log "doublecomma "+obj
          obj=obj.replace(fixdoublespaces, ' ')
          #__cons.log "fixdoublespaces \'"+obj+"\'"
          obj=obj.replace(weirdcomma , '\, ')
          #__cons.log "weird comma \'"+obj+"\'"
          # normalize
          # close square, one or more space, comma, to '] '
          #obj=obj.replace(/\]\s{0,}\,/g , '], ')
          last=obj.length
          ## loop over the configured options
          for option in obj.split(pattern)
            #__cons.log(index+" option=\'"+option+"\'") if __conf._debug
            ## might be a better way than...
            ##  eval'ing unescaped variable data surrounded
            if option isnt undefined and option isnt ""
              if ( /eval\s{0,}\(.+\)/g.test(option) )
                __cons.error("#{_err} -- sorry buddy eval() usage is not allowed.")
                continue
              #option=option.replace( beginningcomma, '[')
              option=option.replace( beginningcomma, '')
              #__cons.log "begining comma \'"+option+"\'"
              option=option.replace( trailingcomma, ']')
              #__cons.log "trailing comma \'"+option+"\'"

              # if length of the text is > 8 then continue
              # most of the api calls are 8 or more.
              if option.length > 8
                option='['+option+']' ## make our string look more like an array for eval.
                #option=new Array(option) # '['+option+']' ## make our string look more like an array for eval.
                #__cons.log "opted \'"+option+"\'"
                try
                  #paqPush(option)
                  #__cons.log (index+" "+ (typeof eval(option)))
                  #paqPush( new Array(option) )
                  paqPush( eval (option) )
                catch e
                  __cons.error("#{_err} paq_push option=#{option} (#{e})")
            index++
      __cons.log("ADVANCED FEATURES END") if __conf._debug?

      #if __conf._debug isnt null
      #  __cons.log("end myPiwikAlias.menuOpts time = "+(__perf.now() - perfThen))
      # return the window._paq array so far
      windowAlias._paq


    ###
# myPiwikAlias.menuOpts
#   the basic menu options
    ###
    myPiwikAlias.menuOpts = ->
      #if __conf._debug isnt null
      #  __cons.log("myPiwikAlias.menuOpts")

      # enable link tracking
      paqPush(['enableLinkTracking',true])

      # determine if DoNotTrack is enabled, default obey if undefined
      if __conf.tracking_do_not_track isnt null
        paqPush(['setDoNotTrack',true])
      else
        paqPush(['setDoNotTrack',false])

      # maybe we can get away with just isnt null and isnt undefined.
      # tracking_group_by_domain
      tmp=__conf.tracking_group_by_domain
      if ( ( tmp isnt undefined ) and
        ( tmp isnt null ) )
          #__cons.log("2 "+unescape( tmp ))
          paqPush( ["setDocumentTitle", "#{document.domain} / #{document.title}" ] )


      # determine if tracking-all-subdomains is enabled
      # check for a number, and an arbitray range between 2 and 15.
      tmp=__conf.tracking_all_subdomains
      if ( not isNaN( tmp ) and
        ( tmp > 1 ) and
            ( tmp <= 15 ) )

        # FIXME this would be much easier if I could access the zone name from within CloudFlare
        # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
        # WORKING -- offer a selection box, with "2nd", "3rd", "4th"
        # level sub domains options
        # prepend a period 
        wildcardZone="."+document.domain.split(".").slice( -1 * tmp ).join(".")
        #__cons.log("setCookieDomain="+wildcardZone) if __conf._debug
        ## setCookieDomain wants a string, may accept an array.
        paqPush(["setCookieDomain", wildcardZone])
        # end if tracking all subdomains


      # tracking_all_aliases -- this could/should just be fetched and possibly set in a cookie.
      tmp=__conf.tracking_all_aliases
      if ( ( tmp isnt undefined ) and
        ( tmp isnt null ) )
          try
            #__cons.log(""+unescape ( __conf.tracking_all_aliases ))
            
            ## setDomains wants an array. Should populate with all the known site aliases
            paqPush(["setDomains", new Array tmp ] )
          catch e
            __cons.error("#{_err} tracking_all_aliases=#{tmp} \(#{e}\)")

      
      ## run the advanced menu options if enabled.
      ## -- the user has been warned that this could negatively effect
      if ( ( __conf.advMenu isnt undefined ) and ( __conf.advMenu isnt null ) )
        #paqPush( eval _paq_push )

        myPiwikAlias.advMenuOpts()

      # Send a trackPageView request to the TrackerUrl
      paqPush( ['trackPageView'] )

      #if __conf._debug isnt null
      #  __cons.log("end myPiwikAlias.menuOpts time = "+(__perf.now() - perfThen))
      # return the window._paq array so far
      windowAlias._paq



    #__cons.log("before menu opts")
    try
      # menuOpts -> then possibly run the advMenuOpts
      myPiwikAlias.menuOpts()
    catch e
      __cons.error("#{_err} Main #{e}")

    if __conf._debug isnt null
      __cons.log(
        "#{(__perf.now() - myPiwikAlias.perfThen )} ms\t"+
        "\"piwik_analytics\" factory exec time"
      )

      #CloudFlare.require(['piwik_analytics/showPerf'])

    #__cons.log("END piwik_analytics")
    # return myPiwikAlias
    myPiwikAlias
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
