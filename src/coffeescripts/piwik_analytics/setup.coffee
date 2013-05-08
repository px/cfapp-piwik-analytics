# vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab

###
* definition for setup
###
CloudFlare.define 'piwik_analytics/setup', [
  'cloudflare/console'
  'piwik_analytics/config'
  'piwik_analytics/perf'
],
  ( __console,
    __config,
      __perf
  ) ->
    #    __console.log("START piwik_analytics/setup")
    setup = {}

    # store the current time
    setup.perfThen = __perf.now()

    __defaultConf = {
      _debug: `false`
      default_debug: yes
      piwik_install:''
      default_piwik_install:'/piwik'
      site_id:''
      default_piwik_site_id:1
      paq_push:""
      tracking_all_subdomains:yes
      tracking_do_not_track: no
    }

    #__config = undefined
    if __config is undefined
      __config = __defaultConf
    
    # for testing on js.cloudflare.com
    if (window.document.location.hostname is "js.cloudflare.com")
      __console.error("js.cloudflare.com sandbox DETECTED! Using developer testing config.")
      __devConf = __defaultConf
      __devConf._debug=`true`
      ##__devConf._debug=`false`
      __devConf.default_piwik_install='//piwik-ssl.ns1.net'
      __devConf.site_id='a'
      __devConf.default_piwik_site_id=28
      __config = __devConf

    
    ## create _paq array
    window._paq = window._paq || []

    setup.setDefault = (v, d, m) ->
      try
        # if the variable is undefined or empty
        if ( v is undefined or v is ""  )
          # output a log message
          __console.error("Invalid "+m+" = \""+v+"\", using default "+ m + " = \""+ d+"\" " )
          # assign the variable the value of the default
          v = d
        # return v
        v
      catch e3 # catch the error
        # perform the assignment of the default value
        v = d
        # output an error message
        __console.error (e3)
        # return v
        v


    ###
# setup.setSiteId()
#
#   checks for a null value, not a number, and assign's SiteId to default
    ###
    setup.setSiteId =
      ( _SiteId ) ->

        #setup.setDefault( _SiteId, __config.default_piwik_site_id, "WebsiteId" )

        # if it's a number use it. Double Negative,
        # will catch, alpha, and use the default above
        if ( ( not isNaN( _SiteId ) ) and ( _SiteId >= 1 ) )
          __console.log( "setup.setSiteId\t = "+ _SiteId ) if setup._debug?
        else
            # default to default_site_id from cloudflare.json
          __console.error( "Invalid WebsiteId = \'"+ _SiteId+
            "\' is not a number; defaulting to \'" + ( __defaultConf.default_piwik_site_id ) + "\'") if setup._debug?
          _SiteId = __defaultConf.default_piwik_site_id
        # end if site_id
        window._paq.push(['setSiteId', unescape ( _SiteId ) ])
        _SiteId

    ###
# mypiwik.setInstall
# sets the tracker for the client to use
    ###
    setup.setInstall =
      (_install ) ->

        _install = setup.setDefault( _install, __config.default_piwik_install, "Install" )

        if setup._debug?
          __console.log("setup.setInstall\t = \""+unescape( _install)+"\"")

        window._paq.push([
          'setTrackerUrl', unescape ( _install ) + "/piwik.php"
        ])
        ###
#return _install
        ###
        _install

    ###
# check for how bad user configured values react
    ###
    #__config.site_id='a'
    #__config.piwik_install=""



    ###
    # configure with the defaults if undefined or invalid
    ###
    setup._debug = setup.setDefault( __config._debug, __defaultConf.default_debug, "Debug" )

    setup.piwik_install = setup.setInstall( __config.piwik_install )

    try
      ## in the future if the SiteId is invalid, we can use the working tracker to fetch the Id based on the domain name
      setup.site_id = setup.setSiteId( __config.site_id )
    catch e
      __console.error("uhoh "+e)
    #__console.log( "Hello from the Piwik Analytics CloudFlare App!" )

    if setup._debug?
      CloudFlare.push( { verbose:1 } )
      window.localStorage.clear()
    #__console.log("END piwik_analytics/setup")

    try
      __console.log(
        (__perf.now() - setup.perfThen) + " ms"+
          "\t piwik_analytics/setup execution time")
    catch e
      __console.error("uhoh "+e)
    
    setup
###
# end of setup module
###

