# This is Miniature Hipster
# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
# piwik_analytics module definition
# REQUIRE:
#  cloudflare/console       for output to console
#  piwik_analytics/perf     for timing module
#  piwik_analytics/config   for user configuration
#  piwik_analytics/tracker  for loading piwik.js library from install url, and sets site id.
#
#
# This main part of the module will erform user configured operations, and the advanced options if enabled.
###

CloudFlare.define 'piwik_analytics', [
  'cloudflare/console'
  'piwik_analytics/perf'
  'piwik_analytics/config'
  'piwik_analytics/tracker'
],
  ( _con, _perf, _cfg, _tracker ) ->
    #    _con.log("START piwik_analytics")

    # define mp module
    # -- to be passed into a "return" later which will cause loading
    myPiwik = {}
    mp=myPiwik

    # set the performance function and create a timer
    # wrap in try or risk failure in some browsers
    mp.perfThen=_perf.now()

    #
    wa = window
    # create or copy so as to not destroy the window._paq for piwik to utilize
    # # done in tracker module
    # wa._paq = wa._paq || []


    ## error string
    _err="uhoh! "

    ## paq pusher
    # push array objects into window._paq with error catching
    paqPush = (ao) =>
      wa=window
      try
        size=0
        switch (typeof ao)
          when "object" then size=wa._paq.push(ao)
          when "string" then size=wa._paq.push([ao])

          else
            _con.error("#{_err} -- not sure what type this is #{(typeof ao)}")

        if _cfg._debug
          _con.log("_paq.length=#{size},\t#{ao}")

      catch error
        _con.error("#{_err} pp (#{error})")

    ##
# mp.isPiwik()
#   pushes a request for piwik to set _isPiwik true once piwik.js executes
#   if it does, then it will return a yes, other no
#
    ##
#    mp.isPiwik = () ->
#      # use strict javascript
#      #"use strict"
#      wa._paq.push [->
#        _isPiwik = yes
#      ]
#      _isPiwik


    ###
# mp.getVisitorId
# pushes a request for the Piwik VisitorId generated once piwik.js executes
# sets the _visitorId to be the id, and returns it's value
# will return the visitorId or false if piwik.js is still not loaded.
#
    ###
    mp.getVisitorId = () ->
      #"use strict"
      _visitorId=no
      wa=window
      wa._paq.push [ ->
        _visitorId = @getVisitorId()
        # output console message with VisitorId once piwik.js is loaded
        _con.log( "Piwik.getVisitorId = #{_visitorId}" ) if _cfg._debug isnt null
        _visitorId
      ]
      _visitorId
      #end getVisitorId


    ###
# mp.advMenuOpts
#
#     Perform advanced configured features.
    ###
    mp.advMenuOpts = ->
      wa=window
      m="ADVANCED FEATURES "
      _con.log(m+"BEGIN") if _cfg._debug?

      _paq_push=_cfg.paq_push
      # pass the extra advanced options if any are configured or allowed
      if ( ( _paq_push isnt undefined ) and
        ( _paq_push isnt null ) )

          index=1
          fixdoublespaces=///
            \s{2,}        ## match two or more sequential spaces
          ///g            ## match all

          doublecomma=///
            (\s{0,}\,)    ## match zero or more spaces and comma
            {2,}          ## two of these
          ///g            ## match all 

          beginningcomma=/// ^ ## begin of line
            (             ## begin match
            [\,\s\S]      ## comma, white space, words
            {0,}          ## zero or more of these
            )             ## end match
            \[            ## open square bracket
          ///

          trailingcomma=///
            \]            ## closing square brace
            (             ## begin match
            [\,\s\S]      ## comma, white space, words
            {0,}          ## zero or more of these
            )             ## end match
            $             ## end of line
          ///

          weirdcomma=///
            \s?\,\s?  ## maybe a space, comma, then maybe space
          ///g

          evileval=///
            eval      ## eval is evil
            \s{0,}    ## zero or more spaces
            \(.+\)    ## parameters
          ///g        ## match all

          # split on ends
          pattern = ///
            \]        ## closing square brace
            \s{0,}    ## zero or more spaces
            \,{0,}    ## zero or more comma
            \s{0,}    ## zero or more spaces, again
            \[?       ## maybe open square bracket
          ///

          ## object
          obj=(_paq_push)
          #_con.log "plain \'"+obj+"\'"
          obj=obj.replace(doublecomma, ", ")
          #_con.log "doublecomma "+obj
          obj=obj.replace(fixdoublespaces, ' ')
          #_con.log "fixdoublespaces \'"+obj+"\'"
          obj=obj.replace(weirdcomma , '\, ')
          #_con.log "weird comma \'"+obj+"\'"
          
          ## loop over the configured options
          for option in obj.split(pattern)
            #_con.log(index+" option=\'"+option+"\'") if _cfg._debug
            ## might be a better way than...
            ##  eval'ing unescaped variable data surrounded
            if option isnt undefined and option isnt ""
              if ( /eval\s{0,}\(.+\)/g.test(option) )
                _con.error("#{_err} -- sorry buddy eval() usage is not allowed.")
                continue

              option=option.replace( beginningcomma, '')
              #_con.log "begining comma \'"+option+"\'"
              option=option.replace( trailingcomma, ']')
              #_con.log "trailing comma \'"+option+"\'"

              # if length of the text is > 8 then continue
              # most of the api calls are 8 or more.
              if option.length > 8
                option='['+option+']' ## make our string look more like an array for eval. new Array is not functional
                try
                  #_con.log (index+" "+ (typeof eval(option)))
                  paqPush( eval (option) )
                catch e
                  _con.error("#{_err} paq_push option=#{option} (#{e})")
            index++
      _con.log(m+"END") if _cfg._debug?

      #if _cfg._debug isnt null
      #  _con.log("end mp.menuOpts time = "+(_perf.now() - perfThen))
      # return the window._paq array so far
      wa._paq


    ###
# mp.menuOpts
#   the basic menu options
    ###
    mp.menuOpts = ->
      #if _cfg._debug isnt null
      #  _con.log("mp.menuOpts")

      # enable link tracking
      paqPush(['enableLinkTracking',true])

      # determine if DoNotTrack is enabled, default obey if undefined
      if _cfg.tracking_do_not_track isnt null
        paqPush(['setDoNotTrack',true])
      else
        paqPush(['setDoNotTrack',false])

      # maybe we can get away with just isnt null and isnt undefined.
      # tracking_group_by_domain
      tmp=_cfg.tracking_group_by_domain
      if ( ( tmp isnt undefined ) and
        ( tmp isnt null ) )
          #_con.log("2 "+unescape( tmp ))
          paqPush( ["setDocumentTitle", "#{document.domain} / #{document.title}" ] )


      # determine if tracking-all-subdomains is enabled
      # check for a number, and an arbitray range between 2 and 15.
      tmp=_cfg.tracking_all_subdomains
      if ( not isNaN( tmp ) and
        ( tmp > 1 ) and
            ( tmp <= 15 ) )

        # FIXME this would be much easier if I could access the zone name from within CloudFlare
        # otherwise we'll have to track all known tld and second level domains and write this logic in; no thanks.
        # WORKING -- offer a selection box, with "2nd", "3rd", "4th"
        # level sub domains options
        # prepend a period 
        wildcardZone="."+document.domain.split(".").slice( -1 * tmp ).join(".")
        #_con.log("setCookieDomain="+wildcardZone) if _cfg._debug
        ## setCookieDomain wants a string, may accept an array.
        paqPush(["setCookieDomain", wildcardZone])
        # end if tracking all subdomains


      # tracking_all_aliases -- this could/should just be fetched and possibly set in a cookie.
      tmp=_cfg.tracking_all_aliases
      if ( ( tmp isnt undefined ) and
        ( tmp isnt null ) )
          try
            #_con.log(""+unescape ( _cfg.tracking_all_aliases ))

            ## setDomains wants an array. Should populate with all the known site aliases
            paqPush(["setDomains", new Array tmp ] )
          catch e
            _con.error("#{_err} tracking_all_aliases=#{tmp} \(#{e}\)")


      ## run the advanced menu options if enabled.
      ## -- the user has been warned that this could negatively effect
      if ( ( _cfg.advMenu isnt undefined ) and ( _cfg.advMenu isnt null ) )
        #paqPush( eval _paq_push )

        mp.advMenuOpts()

      # Send a trackPageView request to the TrackerUrl
      paqPush( ['trackPageView'] )

      #if _cfg._debug isnt null
      #  _con.log("end mp.menuOpts time = "+(_perf.now() - perfThen))
      # return the window._paq array so far
      wa._paq



    #_con.log("before menu opts")
    try
      # menuOpts -> then possibly run the advMenuOpts
      mp.menuOpts()
    catch e
      _con.error("#{_err} Main #{e}")

    if _cfg._debug isnt null
      _con.log(
        "#{(_perf.now() - mp.perfThen )} ms\t"+
        "\"piwik_analytics\" time"
      )

      #CloudFlare.require(['piwik_analytics/showPerf'])

    #_con.log("END piwik_analytics")
    # return mp
    mp
###
#end myPiwik module
###

#window.console.log(
#  "Piwik Analytics CloudFlare App Script load time = "+
#  ( now() - window.perfThen) + " ms")
